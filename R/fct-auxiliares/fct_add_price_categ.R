########################################################################################## #
#'  Função criado para adicionar coluna de categoria de preços
#' 
#'  Autor: Mikael Marin Coletto
#'  Data: 01/06/23
########################################################################################## #


## 0.1 - Bibliotecas e scripts fontes----


## 1.0 - Script/Função ----
func_add_price_categ <- function(df, debug){
  df |> 
    dplyr::mutate(price_categ = dplyr::case_when(price_original > 60 ~ "Muito Caro",
                                                 price_original > 40 ~ "Caro",
                                                 price_original > 20 ~ "Medio",
                                                 price_original > 10 ~ "Barato",
                                                 price_original > 0 ~ "Muito Barato",
                                                 price_original == 0 ~ "Gratuito"))
}
