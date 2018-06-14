#DATA FRA IMDIS API

#libraries
library(httr)
library(jsonlite)
library(dplyr)

#krever at data er på korrekt spørreformat

#funksjon
imdi_fetch = function(data){
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