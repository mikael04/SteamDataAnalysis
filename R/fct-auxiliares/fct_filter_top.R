########################################################################################## #
#'  Script/Função/módulo criado para filtrar categorias da contagem
#'  Lê tabela com a contagem de aparições de cada categoria, ordena e filtra
#'  o número selecionado (n_top)
#' 
#'  Autor: Mikael Marin Coletto
#'  Data: 
########################################################################################## #


## 0.1 - Bibliotecas e scripts fontes----


## 1.0 - Script/Função ----
func_filter_top <- function(df, n_top, debug){
  teste_interno <- F
  if(teste_interno){
    df <- df_games_sample_split
    n_top = 50
    debug = T
  }
  
  tags_top <- data.table::fread(here::here("data-raw/created-tables/df-tags-count.csv")) |> 
    dplyr::arrange(desc(count)) |> 
    dplyr::slice_head(n = n_top) |> 
    dplyr::pull(tag)
  
  df |> 
    dplyr::filter(tolower(tags_all) %in% tags_top)
}
