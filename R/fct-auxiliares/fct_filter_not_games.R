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
func_filter_not_games <- function(df_selected, notGames_col, mode, dbplyr){
  teste_interno <- F
  if(teste_interno){
    df_selected <- df_selected
    notGames_col <- notGames_col
    mode <- 1
    dbplyr <- T
  }
  ## Se rodar em csv, pode ser usado o str_detect
  if(!dbplyr){
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
  ## Se rodar em SQLite, não pode usar e precisa adaptar
  }#else{
  #   # dbGetQuery(steamdb, 'SELECT * FROM db_base_1 LIMIT 5')
  #   if(mode == 1){
  #     # df_selected <- df_selected |>
  #     #   dplyr::mutate(genres = func_filter_not_games_line(genres, notGames))
  #       
  #   #   df_selected <- dbGetQuery(steamdb, "SELECT * FROM db_base_1_raw
  #   #                             WHERE genres NOT LIKE '%Utilities%'
  #   #                               AND genres NOT LIKE '%Design & Illustration%'
  #   #                               AND genres NOT LIKE '%Animation & Modeling%'
  #   #                               AND genres NOT LIKE '%Game Development%'
  #   #                               AND genres NOT LIKE '%Photo Editing%'
  #   #                               AND genres NOT LIKE '%Audio Production%'
  #   #                               AND genres NOT LIKE '%Video Production%'
  #   #                               AND genres NOT LIKE '%Accounting%'
  #   #                               AND genres NOT LIKE '%Movie%'
  #   #                               AND genres NOT LIKE '%Documentary%'
  #   #                               AND genres NOT LIKE '%Episodic%'
  #   #                               AND genres NOT LIKE '%Short%'
  #   #                               AND genres NOT LIKE '%Tutorial%'
  #   #                               AND genres NOT LIKE '%360 Video%';")
  #   #   nrow(df_selected)
  #   # df_selected_1 <- df_selected |> 
  #   #     dplyr::select(AppID, Genres, Categories, Tags)
  #   #   
  #   #   df_selected <- dbGetQuery(steamdb, "SELECT * FROM db_base_1_raw
  #   #                             WHERE genres NOT LIKE '%Utilities%' || '%Design & Illustration%' || '%Animation & Modeling%' ||
  #   #                             '%Game Development%' || '%Photo Editing%' || '%Audio Production%' ||
  #   #                             '%Video Production%' || '%Accounting%' || '%Movie%' || '%Documentary%' ||
  #   #                             '%Episodic%' || '%Short%' || '%Tutorial%' || '%360 Video%' ;")
  #   #   nrow(df_selected)
  #   #   df_selected_2 <- df_selected
  #   #   df_anti_2 <- dplyr::anti_join(df_selected_2, df_selected_1, by="AppID")
  #   #   df_anti_1 <- dplyr::anti_join(df_selected_1, df_selected_2, by="AppID")
  #   #   
  #     # df_selected |> 
  #     #   dplyr::filter(!(stringr::str_detect(genres, notGames_col)))
  #   }
  #   if(mode == 2){
  #     # df_selected <- df_selected |> 
  #     #   dplyr::filter(!(stringr::str_detect(tags, notGames_col)))
  #   }
  #   if(mode == 3){
  #     df_selected <- df_selected |>
  #       dplyr::filter(!(stringr::str_detect(tags_all, notGames_col)))
  #   }
  #   return(df_selected)
  # }
  
  
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
  browser()
  if(row %in% notGames_vector){
    return("notGame")
    print("If")
  }else{
    return(row)
    print("Else")
  }
}

