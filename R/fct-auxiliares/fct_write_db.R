########################################################################################## #
#'  Script/Função/módulo criado para escrever tabelas no banco de dados (SQLite)
#' 
#'  Autor: Mikael Marin Coletto
#'  Data: 09/07/23
########################################################################################## #


## 0.1 - Bibliotecas e scripts fontes----
source(here::here("R/fct-auxiliares/fct_change_date_sql.R"))

## 1.0 - Script/Função ----
func_write_db <- function(df_name, df, con, overwrite, index_list, debug){
  teste_interno <- F
  if(teste_interno){
    df_name = "db_games_3_clean"
    df = df_games_selTags
    con = steamdb
    overwrite = T
    index_list = ""
    debug = F
  }
## Essa função irá converter a coluna de data se houver
  df <- func_change_date_sql(df, debug)
  if(debug){
    # Get the database name
    dbname <- stringr::str_extract(DBI::dbGetInfo(con)$dbname, "(?<=/)[^/]*$")
    dbname <- stringr::str_extract(dbname, "^[^.]*")
    print(paste0("Escrevendo df = ", df_name,  " no db = ", dbname))
    print(paste0("Sobrescrever = ", overwrite))
    print(paste0("Index list = ", index_list))
  }
  if(overwrite){
    if(DBI::dbExistsTable(con, df_name)){
      DBI::dbRemoveTable(con, df_name)
    }
    dbplyr::db_copy_to(con, df_name, df, overwrite, temporary = F, message = F)
  }
}
