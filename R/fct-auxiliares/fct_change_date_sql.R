########################################################################################## #
#'  Script/Função/módulo criado para testar se existe variavel do tipo data, se sim
#'  converter para character
#' 
#'  Autor: Mikael Marin Coletto
#'  Data: 
########################################################################################## #


## 0.1 - Bibliotecas e scripts fontes----


## 1.0 - Script/Função ----
func_change_date_sql <- function(df, debug){
  teste_interno <- F
  if(teste_interno){
    df <- df_all_games
    debug <- T
  }
  for(col in names(df)){
    if (!inherits(df[[col]], 'Date')) {
      if(debug)
        print(paste(col, 'is not a Date type'))
    }else{
      if(debug)
        print(paste(col, 'IS Date type'))
      df[[col]] = as.character(df[[col]])
    }
  }
  df
}