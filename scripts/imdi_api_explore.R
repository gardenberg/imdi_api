#libraries
library(httr)
library(jsonlite)
library(dplyr)

#METADATA

#hvilke tabeller finnes?
url = "https://imdifakta.azurewebsites.net/api/v1/metadata/tables"
test_tabeller = GET(url)
#henter ut data med fromJSON fra jsonlite
df = fromJSON(content(test_tabeller,"text",encoding="UTF-8"))

#hvilke headere finnes for en tabell?
url = "https://imdifakta.azurewebsites.net/api/v1/metadata/headers/befolkning_alder"
test_tabeller = GET(url)
df = fromJSON(content(test_tabeller,"text",encoding="UTF-8"))
df$headers

#hvilke grupper av headere finnes for en tabell?
url = "https://imdifakta.azurewebsites.net/api/v1/metadata/headergroups/befolkning_alder"
test_tabeller = GET(url)
df = fromJSON(content(test_tabeller,"text",encoding="UTF-8"))

#LITT UTFORSKING av dataene
#bruker http-metoder fra httr-pakka for å hente data fra IMDis API.
#APIet er ikke dokumentert, men kan utforskes ved hjelp av en nettleser-konsoll som f.eks. chrome

#henter data fra query-api
url = "https://imdifakta.azurewebsites.net/api/v1/data/query"
data = '{"TableName":"befolkning_hovedgruppe","Include":["innvkat5","kjonn","fylkeNr","enhet","aar"],"Conditions":{"innvkat5":["innvandrere","bef_u_innv_og_norskf","norskfodte_m_innvf"],"kjonn":["alle"],"fylkeNr":["00"],"enhet":["personer"]}}{"TableName":"befolkning_hovedgruppe","Include":["innvkat5","kjonn","fylkeNr","enhet","aar"],"Conditions":{"innvkat5":["innvandrere","bef_u_innv_og_norskf","norskfodte_m_innvf"],"kjonn":["alle"],"fylkeNr":["00"],"enhet":["personer"]}}'

HEAD(url) #405-error, method not allowed. HEAD skal vel egentlig alltid være lov, men ok.

#ma ha med content_type_json() for a fa 200 ok
test = POST(url,body=data,encode="json",verbose(),content_type_json())

#returnerer en liste på 10 elementer

#henter ut data med fromJSON fra jsonlite
df = fromJSON(content(test,"text",encoding="UTF-8"))
#gir en liste med ett element
df = df[[1]]
head(df)

#MER STRUKTURERT
#hjelpefunksjon
imdi_fetch = function(data){
  temp_queryresult = POST("https://imdifakta.azurewebsites.net/api/v1/data/query",body=data,encode="json",verbose(),content_type_json())
  temp_df = fromJSON(content(temp_queryresult,"text",encoding="UTF-8"))
  return(temp_df)
}

#CONTINUATION TOKEN ved større spørringer
#dersom en spørring gir mer enn 500 svar, vil det følge med en continuation token.
#bosettingsdataene gir meg en continuation-token.

#befolkningsdata, IMDI-API
tabellnavn = "bosatt_anmodede"
data = '{"TableName":"bosatt_anmodede",
  "Include":["bosetting","kommuneNr","enhet","aar"],
  "Conditions":{
    "bosetting":["bosatt"],
    "enhet":["personer"],
    "aar":["2013","2014","2015","2016","2017"]
}}'
test = POST(url,body=data,encode="json",verbose(),content_type_json())
#returnerer en liste på 10 elementer
#henter ut data med fromJSON fra jsonlite
df = fromJSON(content(test,"text",encoding="UTF-8"))
#gir en liste med to elementer - continuation og data
df$continuation

#for å hente resten av dataene må en sende en ny spørring med token inkludert
token = df$continuation

#hvordan paster en inn dette da, masse " og '

token_format = paste0('"continuation":"',token,'",')

data = paste0(
  '{',
  token_format,
  '"TableName":"bosatt_anmodede",
  "Include":["bosetting","kommuneNr","enhet","aar"],
"Conditions":{
"bosetting":["bosatt"],
"enhet":["personer"],
"aar":["2013","2014","2015","2016","2017"]
}}')
  
test_2 = POST(url,body=data,encode="json",verbose(),content_type_json())
#returnerer en liste på 10 elementer
#henter ut data med fromJSON fra jsonlite
df_2 = fromJSON(content(test_2,"text",encoding="UTF-8"))
#fortsatt en liste på to.

#sammenlikner de to datasettene
test_df1 = df[[2]]
test_df2 = df_2[[2]]
test_df = bind_rows(test_df1,test_df2)

#for å komme i mål med datasettet må en dermed legge inn en loop.

imdi_fetch_long = function(data){
  temp_queryresult = POST("https://imdifakta.azurewebsites.net/api/v1/data/query",body=data,encode="json",verbose(),content_type_json())
  temp_df = fromJSON(content(temp_queryresult,"text",encoding="UTF-8"))
  if(length(temp_df)==1){
    return(temp_df[[1]])
  }
  if(length(temp_df)>1){
    temp_df_final = data.frame()
    temp_df_final = bind_rows(temp_df_final,temp_df[[2]])
    i = 0
  }
  #bruker en while-loop, og det er vel fy?
  while(length(temp_df)>1){
    i = i+1
    temp_token = temp_df$continuation
    temp_token_format = paste0('{','"continuation":"',temp_token,'",')
    new_data = substring(data,2,nchar(data)+1)
    new_data_query =paste0(temp_token_format,new_data)
    temp_queryresult = POST("https://imdifakta.azurewebsites.net/api/v1/data/query",body=new_data_query,encode="json",verbose(),content_type_json())
    temp_df = fromJSON(content(temp_queryresult,"text",encoding="UTF-8"))
    if(length(temp_df)>1){
      temp_df_final = bind_rows(temp_df_final,temp_df[[2]])
      Sys.sleep(5) #høfflig å ikke spørre for mange ganger
    }
    if(length(temp_df)==1){
      temp_df_final = bind_rows(temp_df_final,temp_df[[1]])
      print(paste0("Fullført på ",i," repetisjoner"))
    }
  }
  return(temp_df_final)
}

tabellnavn = "bosatt_anmodede"
data = '{"TableName":"bosatt_anmodede",
"Include":["bosetting","kommuneNr","enhet","aar"],
"Conditions":{
"bosetting":["bosatt"],
"enhet":["personer"],
"aar":["2013","2014","2015","2016","2017"]
}}'

df = imdi_fetch_long(data)
head(df)

#tester også om den håndtrer ikke-lange datasett
url = "https://imdifakta.azurewebsites.net/api/v1/data/query"
data = '{"TableName":"befolkning_hovedgruppe","Include":["innvkat5","kjonn","fylkeNr","enhet","aar"],"Conditions":{"innvkat5":["innvandrere","bef_u_innv_og_norskf","norskfodte_m_innvf"],"kjonn":["alle"],"fylkeNr":["00"],"enhet":["personer"]}}{"TableName":"befolkning_hovedgruppe","Include":["innvkat5","kjonn","fylkeNr","enhet","aar"],"Conditions":{"innvkat5":["innvandrere","bef_u_innv_og_norskf","norskfodte_m_innvf"],"kjonn":["alle"],"fylkeNr":["00"],"enhet":["personer"]}}'
df = imdi_fetch_long(data)

#tester på intro-data
tabellnavn="intro_status_arbutd"
#først litt bakgrunnsinfo
#hvilke headere finnes?
url = paste0("https://imdifakta.azurewebsites.net/api/v1/metadata/headers/",tabellnavn)
headere = GET(url)
df = fromJSON(content(headere,"text",encoding="UTF-8"))
df$headers
#hvilke grupper av headere finnes for en tabell?
url = paste0("https://imdifakta.azurewebsites.net/api/v1/metadata/headergroups/",tabellnavn)
headergrupper = GET(url)
df_hg = fromJSON(content(headergrupper,"text",encoding="UTF-8"))

#så selve dataene. vil ha kjønn for alle kommuner
data = '{"TableName": "intro_status_arbutd",
  "Conditions": {
    "enhet": ["personer"]
  },
  "Include": [
    "kjonn",
    "avslstat4",
    "enhet",
    "aar",
    "kohort",
    "kommuneNr"
    ],
  "Exclude": []
}'
  
  
df = imdi_fetch_long(data)
write.csv2(df,"data/intro_status_arbutd.csv",row.names = FALSE)
#det ser ut til at å utelate en variabel fra conditions, ganske enkelt henter alt den har å by på.