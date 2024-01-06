########################################################################################## #
#'  Função criado para adicionar coluna de categoria conforme classificação 
#'  da data de lançamento
#' 
#'  Autor: Mikael Marin Coletto
#'  Data: 06/01/24
########################################################################################## #


## 0.1 - Bibliotecas e scripts fontes----


## 1.0 - Script/Função ----
func_add_date_categ <- function(df, debug){
  df |> 
    dplyr::mutate(date_categ = case_when(
      date_release > lubridate::ymd("2022-04-27") ~ "new",
      date_release > lubridate::ymd("2018-04-27") ~ "recent",
      date_release > lubridate::ymd("2013-04-27") ~ "old",
      .default = "very old"
      ))
}

func_add_date_categ_num <- function(df, debug){
  df |> 
    dplyr::mutate(date_categ = case_when(
      date_release > lubridate::ymd("2022-04-27") ~ "new",
      date_release > lubridate::ymd("2018-04-27") ~ "recent",
      date_release > lubridate::ymd("2013-04-27") ~ "old",
      .default = "very old"
    ))
}