########################################################################################## #
#'  Script/Função/módulo criado para filtrar generos do tipo não jogo
#'  que são passados por parâmetro
#'  1. A função 1 filtra o dataframe inteiro e devolve o df, é utilizado por
#'  parâmetro de modo, sendo:
#'  mode == 1, comparação com gêneros
#'  mode == 2, comparação com tags
#'  mode == 3, comparação com tags_all
#'  
#'  2. Filtrando por linha (modo pipeável), nesse caso substituirá a coluna por "notGame"
#' 
#'  Autor: Mikael Marin Coletto
#'  Data: 
########################################################################################## #

## 0.1 - Bibliotecas e scripts fontes----

## 1. - Função para filtrar um dataframe inteiro ----
func_filter_not_games <- function(df_selected, notGames_col, mode){
  if(mode == 1){
    df_selected <- df_selected |> 
      dplyr::filter(!(stringr::str_detect(genres, notGames_col)))
  }
  if(mode == 2){
    df_selected <- df_selected |> 
    dplyr::filter(!(stringr::str_detect(tags, notGames_col)))
  }
  if(mode == 3){
    df_selected <- df_selected |>
      dplyr::filter(!(stringr::str_detect(tags_all, notGames_col)))
  }
  return(df_selected)
  
  ## Esses eram dois jogos que foram investigados
  ## Eles possuíam categorias Movie e Documentary também, então esses registros foram apagados e os demais foram mantidos
  
  # df_full_search <- df_full |> 
  #   dplyr::filter(Name %in% c("Spacelords", "CAT SUDOKU🐱"))
}

## 2. Função para filtrar por linhas
func_filter_not_games_line <- function(row, notGames_vector){
  teste_interno <- F
  if(teste_interno){
    row <- "Utilities"
    notGames_vector <- notGames
  }
  if(row %in% notGames_vector){
    return("notGame")
    # print("If")
  }else{
    return(row)
    # print("Else")
  }
}

