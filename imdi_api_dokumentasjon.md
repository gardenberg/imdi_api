IMDIs tall-og-statistikk-API
================

Metadata
--------

(for å se koden under i en script fil, se [her](https://github.com/gardenberg/imdi_api/blob/master/scripts/imdi_api_explore.R)) En kan sende GET-spørringer for å få vite hvilke tabeller som finnes, og hvilke headere og header-grupper en tabell har.

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

### Hvilke tabeller finnes

Henter ut en oversikt over tabeller med GET fra httr-biblioteket, og konverterer det til en data.frame fra JSON med fromJSON fra jsonlite-pakka.

``` r
url = "https://imdifakta.azurewebsites.net/api/v1/metadata/tables"
test_tabeller = GET(url)
str(test_tabeller)
```

    ## List of 10
    ##  $ url        : chr "https://imdifakta.azurewebsites.net/api/v1/metadata/tables"
    ##  $ status_code: int 200
    ##  $ headers    :List of 9
    ##   ..$ cache-control    : chr "no-cache"
    ##   ..$ pragma           : chr "no-cache"
    ##   ..$ transfer-encoding: chr "chunked"
    ##   ..$ content-type     : chr "application/json; charset=utf-8"
    ##   ..$ content-encoding : chr "gzip"
    ##   ..$ expires          : chr "-1"
    ##   ..$ vary             : chr "Accept-Encoding"
    ##   ..$ set-cookie       : chr "ARRAffinity=e86b5a9ea10035046b91043435e597242fe42e87c3ee7cc19502a2c2c7b16b75;Path=/;HttpOnly;Domain=imdifakta.a"| __truncated__
    ##   ..$ date             : chr "Thu, 14 Jun 2018 07:53:47 GMT"
    ##   ..- attr(*, "class")= chr [1:2] "insensitive" "list"
    ##  $ all_headers:List of 1
    ##   ..$ :List of 3
    ##   .. ..$ status : int 200
    ##   .. ..$ version: chr "HTTP/1.1"
    ##   .. ..$ headers:List of 9
    ##   .. .. ..$ cache-control    : chr "no-cache"
    ##   .. .. ..$ pragma           : chr "no-cache"
    ##   .. .. ..$ transfer-encoding: chr "chunked"
    ##   .. .. ..$ content-type     : chr "application/json; charset=utf-8"
    ##   .. .. ..$ content-encoding : chr "gzip"
    ##   .. .. ..$ expires          : chr "-1"
    ##   .. .. ..$ vary             : chr "Accept-Encoding"
    ##   .. .. ..$ set-cookie       : chr "ARRAffinity=e86b5a9ea10035046b91043435e597242fe42e87c3ee7cc19502a2c2c7b16b75;Path=/;HttpOnly;Domain=imdifakta.a"| __truncated__
    ##   .. .. ..$ date             : chr "Thu, 14 Jun 2018 07:53:47 GMT"
    ##   .. .. ..- attr(*, "class")= chr [1:2] "insensitive" "list"
    ##  $ cookies    :'data.frame': 1 obs. of  7 variables:
    ##   ..$ domain    : chr "#HttpOnly_.imdifakta.azurewebsites.net"
    ##   ..$ flag      : logi TRUE
    ##   ..$ path      : chr "/"
    ##   ..$ secure    : logi FALSE
    ##   ..$ expiration: POSIXct[1:1], format: NA
    ##   ..$ name      : chr "ARRAffinity"
    ##   ..$ value     : chr "e86b5a9ea10035046b91043435e597242fe42e87c3ee7cc19502a2c2c7b16b75"
    ##  $ content    : raw [1:1129] 5b 22 62 65 ...
    ##  $ date       : POSIXct[1:1], format: "2018-06-14 07:53:47"
    ##  $ times      : Named num [1:6] 0 0.094 0.125 0.188 0.25 0.25
    ##   ..- attr(*, "names")= chr [1:6] "redirect" "namelookup" "connect" "pretransfer" ...
    ##  $ request    :List of 7
    ##   ..$ method    : chr "GET"
    ##   ..$ url       : chr "https://imdifakta.azurewebsites.net/api/v1/metadata/tables"
    ##   ..$ headers   : Named chr "application/json, text/xml, application/xml, */*"
    ##   .. ..- attr(*, "names")= chr "Accept"
    ##   ..$ fields    : NULL
    ##   ..$ options   :List of 3
    ##   .. ..$ useragent: chr "libcurl/7.56.1 r-curl/3.1 httr/1.3.1"
    ##   .. ..$ cainfo   : chr "C:/PROGRA~1/R/R-34~1.3/etc/curl-ca-bundle.crt"
    ##   .. ..$ httpget  : logi TRUE
    ##   ..$ auth_token: NULL
    ##   ..$ output    : list()
    ##   .. ..- attr(*, "class")= chr [1:2] "write_memory" "write_function"
    ##   ..- attr(*, "class")= chr "request"
    ##  $ handle     :Class 'curl_handle' <externalptr> 
    ##  - attr(*, "class")= chr "response"

``` r
df = fromJSON(content(test_tabeller,"text",encoding="UTF-8"))
df
```

    ##  [1] "befolkning_alder"                 
    ##  [2] "befolkning_opprinnelsesland_botid"
    ##  [3] "befolkning_verdensregion_6"       
    ##  [4] "befolkning_verdensregion_9"       
    ##  [5] "befolkning_verdensregion"         
    ##  [6] "befolkning_verdensregion_3"       
    ##  [7] "bosetting_maaned"                 
    ##  [8] "bosetting"                        
    ##  [9] "intro_deltakere"                  
    ## [10] "intro_avslutning_direkte"         
    ## [11] "intro_avslutning_direkte_3"       
    ## [12] "norsk_deltakere"                  
    ## [13] "norsk_prover"                     
    ## [14] "voksne_grunnskole"                
    ## [15] "videregaende_fullfort"            
    ## [16] "videregaende_deltakelse"          
    ## [17] "ungdom_utenfor_opplaring"         
    ## [18] "utdanningsniva"                   
    ## [19] "befolkning_opprinnelsesland"      
    ## [20] "flyktning_botid_flytting"         
    ## [21] "bosatt_befolkning"                
    ## [22] "voksne_videregaende"              
    ## [23] "befolkning_botid"                 
    ## [24] "sosialhjelp"                      
    ## [25] "befolkning_hovedgruppe"           
    ## [26] "grunnskolepoeng"                  
    ## [27] "grunnskolepoeng_innvandrere"      
    ## [28] "intro_status_arbutd"              
    ## [29] "intro_avslutning_direkte_8"       
    ## [30] "gjennomsnittsinntekt"             
    ## [31] "vedvarende_lavinntekt"            
    ## [32] "tilskudd"                         
    ## [33] "befolkning_innvandringsgrunn"     
    ## [34] "sysselsatte_innvandringsgrunn"    
    ## [35] "sysselsatte_innvkat"              
    ## [36] "sysselsatte_innvkat_alder"        
    ## [37] "sysselsatte_botid"                
    ## [38] "sysselsatte_botid_land"           
    ## [39] "sysselsatte_kjonn_land"           
    ## [40] "sysselsatte_land"                 
    ## [41] "ikke_arbutd_innvkat_land"         
    ## [42] "ikke_arbutd_innvkat_alder"        
    ## [43] "arbledige_innvkat_land"           
    ## [44] "bosatt_anmodede"                  
    ## [45] "enslige_mindrearige"              
    ## [46] "befolkning_flytting"              
    ## [47] "befolkning_flytting_vreg"         
    ## [48] "barnehagedeltakelse"

APIet inneholder p.t. 48 datasett. Navnene er nogenlunde beskrivende for innholdet i hvert enkelt datasett

### Headere

Hver tabell har "headere", eller variabelnavn, som f.eks. kommune\_nr eller kjonn. Duisse kan spesifiseres nærmere i den faktiske spørringa etter data, og det er derfor viktig å vite hvilke alternativer en har.

``` r
url = "https://imdifakta.azurewebsites.net/api/v1/metadata/headers/befolkning_alder"
test_tabeller = GET(url)
df = fromJSON(content(test_tabeller,"text",encoding="UTF-8"))
df$headers
```

    ## [[1]]
    ##  [1] "aar"             "bydelNr"         "innvkat3"       
    ##  [4] "kjonn"           "enhet"           "alderGrupper"   
    ##  [7] "tabellvariabel"  "fylkeNr"         "kommuneNr"      
    ## [10] "naringsregionNr"

### Header-grupper

Kanskje vel så viktig som å vite hvilke variabler som er tilgjengelig, er å vite hvilke kombinasjoner av variabler og variabel-verdier som er tilgjengelig. F.eks. har en data på kommune\_nr og kjonn (som da er en header-gruppe) separat fra data på fylke\_nr og kjonn (som da er en annen header-gruppe). En kan da ikke spørre på kommune\_nr og fylke\_nr samtidig, så langt jeg veit.

``` r
url = "https://imdifakta.azurewebsites.net/api/v1/metadata/headergroups/befolkning_alder"
test_tabeller = GET(url)
df = fromJSON(content(test_tabeller,"text",encoding="UTF-8"))
df
```

    ##                                                                      aar
    ## 1 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2015, 2016, 2014, 2017
    ## 2 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2015, 2016, 2014, 2017
    ## 3 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2015, 2016, 2014, 2017
    ## 4 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2015, 2016, 2014, 2017
    ##                                                                                                                                                  bydelNr
    ## 1 030101, 030102, 030103, 030104, 030105, 030106, 030107, 030108, 030109, 030110, 030111, 030112, 030113, 030114, 030115, 030116, 030117, 030199, 000301
    ## 2                                                                                                                                                   NULL
    ## 3                                                                                                                                                   NULL
    ## 4                                                                                                                                                   NULL
    ##                                 innvkat3      kjonn    enhet
    ## 1 alle, befolkningen_ellers, innvandrere 0, 1, alle personer
    ## 2 alle, befolkningen_ellers, innvandrere 0, 1, alle personer
    ## 3 alle, befolkningen_ellers, innvandrere 0, 1, alle personer
    ## 4 alle, befolkningen_ellers, innvandrere 0, 1, alle personer
    ##                                       alderGrupper
    ## 1 0_5, 16_19, 20_29, 30_54, 55_66, 6_15, 67+, alle
    ## 2 0_5, 16_19, 20_29, 30_54, 55_66, 6_15, 67+, alle
    ## 3 0_5, 16_19, 20_29, 30_54, 55_66, 6_15, 67+, alle
    ## 4 0_5, 16_19, 20_29, 30_54, 55_66, 6_15, 67+, alle
    ##                                                                              fylkeNr
    ## 1                                                                               NULL
    ## 2 00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 14, 15, 16, 17, 18, 19, 20, 99
    ## 3                                                                               NULL
    ## 4                                                                               NULL
    ##                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            kommuneNr
    ## 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               NULL
    ## 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               NULL
    ## 3 0101, 0104, 0105, 0106, 0111, 0118, 0119, 0121, 0122, 0123, 0124, 0125, 0127, 0128, 0135, 0136, 0137, 0138, 0211, 0213, 0214, 0215, 0216, 0217, 0219, 0220, 0221, 0226, 0227, 0228, 0229, 0230, 0231, 0233, 0234, 0235, 0236, 0237, 0238, 0239, 0301, 0402, 0403, 0412, 0415, 0417, 0418, 0419, 0420, 0423, 0425, 0426, 0427, 0428, 0429, 0430, 0432, 0434, 0436, 0437, 0438, 0439, 0441, 0501, 0502, 0511, 0512, 0513, 0514, 0515, 0516, 0517, 0519, 0520, 0521, 0522, 0528, 0529, 0532, 0533, 0534, 0536, 0538, 0540, 0541, 0542, 0543, 0544, 0545, 0602, 0604, 0605, 0612, 0615, 0616, 0617, 0618, 0619, 0620, 0621, 0622, 0623, 0624, 0625, 0626, 0627, 0628, 0631, 0632, 0633, 0701, 0702, 0704, 0706, 0709, 0711, 0713, 0714, 0716, 0719, 0720, 0722, 0723, 0728, 0805, 0806, 0807, 0811, 0814, 0815, 0817, 0819, 0821, 0822, 0826, 0827, 0828, 0829, 0830, 0831, 0833, 0834, 0901, 0904, 0906, 0911, 0912, 0914, 0919, 0926, 0928, 0929, 0935, 0937, 0938, 0940, 0941, 1001, 1002, 1003, 1004, 1014, 1017, 1018, 1021, 1026, 1027, 1029, 1032, 1034, 1037, 1046, 1101, 1102, 1103, 1106, 1111, 1112, 1114, 1119, 1120, 1121, 1122, 1124, 1127, 1129, 1130, 1133, 1134, 1135, 1141, 1142, 1144, 1145, 1146, 1149, 1151, 1160, 1201, 1211, 1216, 1219, 1221, 1222, 1223, 1224, 1227, 1228, 1231, 1232, 1233, 1234, 1235, 1238, 1241, 1242, 1243, 1244, 1245, 1246, 1247, 1251, 1252, 1253, 1256, 1259, 1260, 1263, 1264, 1265, 1266, 1401, 1411, 1412, 1413, 1416, 1417, 1418, 1419, 1420, 1421, 1422, 1424, 1426, 1428, 1429, 1430, 1431, 1432, 1433, 1438, 1439, 1441, 1443, 1444, 1445, 1449, 1502, 1504, 1505, 1511, 1514, 1515, 1516, 1517, 1519, 1520, 1523, 1524, 1525, 1526, 1528, 1529, 1531, 1532, 1534, 1535, 1539, 1543, 1545, 1546, 1547, 1548, 1551, 1554, 1557, 1560, 1563, 1566, 1567, 1571, 1573, 1576, 1601, 1612, 1613, 1617, 1620, 1621, 1622, 1624, 1627, 1630, 1632, 1633, 1634, 1635, 1636, 1638, 1640, 1644, 1648, 1653, 1657, 1662, 1663, 1664, 1665, 1702, 1703, 1711, 1714, 1717, 1718, 1719, 1721, 1724, 1725, 1736, 1738, 1739, 1740, 1742, 1743, 1744, 1748, 1749, 1750, 1751, 1755, 1756, 1804, 1805, 1811, 1812, 1813, 1815, 1816, 1818, 1820, 1822, 1824, 1825, 1826, 1827, 1828, 1832, 1833, 1834, 1835, 1836, 1837, 1838, 1839, 1840, 1841, 1845, 1848, 1849, 1850, 1851, 1852, 1853, 1854, 1856, 1857, 1859, 1860, 1865, 1866, 1867, 1868, 1870, 1871, 1874, 1902, 1903, 1911, 1913, 1917, 1919, 1920, 1922, 1923, 1924, 1925, 1926, 1927, 1928, 1929, 1931, 1933, 1936, 1938, 1939, 1940, 1941, 1942, 1943, 2002, 2003, 2004, 2011, 2012, 2014, 2015, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2027, 2028, 2030, 1901, 0710
    ## 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               NULL
    ##                                                                                                                                                                                                                                                                                                                              naringsregionNr
    ## 1                                                                                                                                                                                                                                                                                                                                       NULL
    ## 2                                                                                                                                                                                                                                                                                                                                       NULL
    ## 3                                                                                                                                                                                                                                                                                                                                       NULL
    ## 4 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83

Faktiske data
-------------

Så til den faktiske data-spørringen. Den sendes med å poste en spørring til en nettadresse. Spørringen er formatert som JSON, det samme som utformatet tilbake.

``` r
#henter data fra query-api
url = "https://imdifakta.azurewebsites.net/api/v1/data/query"
data = 
  '{"TableName":"befolkning_hovedgruppe",
  "Include":
    ["innvkat5","kjonn","fylkeNr","enhet","aar"],
    "Conditions":
      {"innvkat5":["innvandrere","bef_u_innv_og_norskf","norskfodte_m_innvf"],
      "kjonn":["alle"],
      "fylkeNr":["00"],
      "enhet":["personer"]
    }
}'

#ma ha med content_type_json() for a fa 200 ok
test = POST(url,body=data,encode="json",verbose(),content_type_json())
```

``` r
df = fromJSON(content(test,"text",encoding="UTF-8"))
df = df[[1]]
head(df)
```

    ##    aar fylkeNr             innvkat5 kjonn    enhet tabellvariabel
    ## 1 2017      00          innvandrere  alle personer         724987
    ## 2 2017      00   norskfodte_m_innvf  alle personer         158764
    ## 3 2017      00 bef_u_innv_og_norskf  alle personer        4374566
    ## 4 2015      00          innvandrere  alle personer         669380
    ## 5 2015      00   norskfodte_m_innvf  alle personer         135583
    ## 6 2015      00 bef_u_innv_og_norskf  alle personer        4360839

Hvis APIet gir mer enn 500 svar tilbake, får en med en continuation-token, som må håndteres. Her er en funksjon som ser ut til å gjøre det greit.

(for å se koden under i en script fil, se [her](https://github.com/gardenberg/imdi_api/blob/master/scripts/imdi_api_function.R))

``` r
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
      Sys.sleep(5) #høfflig å ikke spørre for mange ganger på kort tid, derfor sleep 5 sek.
    }
    if(length(temp_df)==1){
      temp_df_final = bind_rows(temp_df_final,temp_df[[1]])
      print(paste0("Fullført på ",i," repetisjoner"))
    }
  }
  return(temp_df_final)
}
```

``` r
data = 
  '{"TableName":"befolkning_hovedgruppe",
  "Include":
    ["innvkat5","kjonn","kommuneNr","enhet","aar"],
    "Conditions":
      {"innvkat5":["innvandrere","bef_u_innv_og_norskf","norskfodte_m_innvf"],
      "kjonn":["alle"],
      "aar": ["2017"],
      "enhet":["personer"]
    }
}'

df=imdi_fetch(data)
```

    ## 
    ## 
    ## 
    ## [1] "Fullført på 2 repetisjoner"

``` r
head(df)
```

    ##    aar kommuneNr             innvkat5 kjonn    enhet tabellvariabel
    ## 1 2017      0101          innvandrere  alle personer           3425
    ## 2 2017      0101   norskfodte_m_innvf  alle personer            939
    ## 3 2017      0101 bef_u_innv_og_norskf  alle personer          26426
    ## 4 2017      0104          innvandrere  alle personer           5249
    ## 5 2017      0104   norskfodte_m_innvf  alle personer           1472
    ## 6 2017      0104 bef_u_innv_og_norskf  alle personer          25686
