#' help_dev_names 
#'
#' @description A function that will help with Developers manipulation
#' 1 - Organize names into one vector of strings
#' 2 - clean developers names
#'
#' @return The return value will depend on function (organ_names -> one column names, clean_dev_names -> names cleaned)
#' 1 - A df with one column of strings (names)
#' 2 - A character vector with the new developers names after manipulation
#' 
#' @noRd


func_organ_names <- function(df, read_df){
  if(read_df){
    df <- read.csv2("data-raw/steam-data/db-0/applicationDevelopers.csv", col.names = paste("V",1:15), fill = T, sep = ",")
    df <- df[,which(!is.na(df[1,]))]
    ## Removendo primeira coluna com "identificador"
    df <- df[,2:8]
  }
  ## Criando vetor com valores únicos de desenvolvedores
  all_developers <- c("")
  for(i in 1:ncol(df)){
    all_developers <- unique(c(all_developers, unique(df[,i])))
  }
  
  ## Criando df/vetor com todas as colunas
  df_aux <- as.matrix(df[,1])
  for(i in 2:ncol(df)){
    df_aux <- append(df_aux, df[,i], after = length(df_aux))
  }
  df_aux <- as.data.frame(df_aux) |> 
    dplyr::filter(df_aux != "") |> 
    dplyr::rename(devs = df_aux)
}

func_clean_dev_names <- function(dev_names){
  ## Limpando nomes problemáticos
  teste_interno <- F
  if(teste_interno){
    dev_names <- df_aux
  }
  ## Removendo variação Linux/Mac mesma empresa (Empresa Aspyr)
  df_all_words <- stringr::str_remove(dev_names$devs, "Linux")
  df_all_words <- stringr::str_remove(df_all_words, "Mac")
  df_all_words <- stringr::str_remove(df_all_words, "& Windows Update")
  df_all_words <- stringr::str_remove(df_all_words, "Studios")
  df_all_words <- as.data.frame(df_all_words) |> 
    dplyr::rename(devs = df_all_words)
  
  
  df_all_words <- df_all_words |> 
    dplyr::mutate(devs = dplyr::if_else(stringr::str_detect(devs, "Aspyr"), "Aspyr", devs))
  
  ## Agrupando todas as desenvolvedores 2K
  df_all_words <- df_all_words |> 
    dplyr::mutate(devs = dplyr::if_else(stringr::str_detect(devs, "2K"), "2K", devs))
  
  ## Agrupando todas as desenvolvedores BANDAI NAMCO
  df_all_words <- df_all_words |> 
    dplyr::mutate(devs = dplyr::if_else(stringr::str_detect(devs, stringr::fixed('BANDAI NAMCO', ignore_case=TRUE)), "Bandai Namco", devs))
  
  ## Agrupando todas as desenvolvedores Behaviour
  df_all_words <- df_all_words |> 
    dplyr::mutate(devs = dplyr::if_else(stringr::str_detect(devs, stringr::fixed('Behaviour', ignore_case=TRUE)), "Behaviour", devs))
  
  ## Agrupando todas as desenvolvedores Capcom
  df_all_words <- df_all_words |> 
    dplyr::mutate(devs = dplyr::if_else(stringr::str_detect(devs, stringr::fixed('Capcom', ignore_case=TRUE)), "Capcom", devs))
  
  ## Agrupando todas as desenvolvedores Codemasters
  df_all_words <- df_all_words |> 
    dplyr::mutate(devs = dplyr::if_else(stringr::str_detect(devs, stringr::fixed('Codemasters', ignore_case=TRUE)), "Codemasters", devs))
  
  ## Agrupando todas as desenvolvedores EA
  df_all_words <- df_all_words |> 
    dplyr::mutate(devs = dplyr::if_else(stringr::str_detect(devs, stringr::fixed('EA', ignore_case=TRUE)), "EA", devs))
  
  ## Agrupando todas as desenvolvedores Konami
  df_all_words <- df_all_words |> 
    dplyr::mutate(devs = dplyr::if_else(stringr::str_detect(devs, stringr::fixed('Konami', ignore_case=TRUE)), "Konami", devs))
  
  ## Agrupando todas as desenvolvedores Rockstar
  df_all_words <- df_all_words |> 
    dplyr::mutate(devs = dplyr::if_else(stringr::str_detect(devs, stringr::fixed('Rockstar', ignore_case=TRUE)), "Rockstar", devs))
  
  ## Agrupando todas as desenvolvedores Ubisoft
  df_all_words <- df_all_words |> 
    dplyr::mutate(devs = dplyr::if_else(stringr::str_detect(devs, stringr::fixed('Ubisoft', ignore_case=TRUE)), "Ubisoft", devs))
  
  df_all_words$devs <- tolower(df_all_words$devs)
  df_all_words$devs <- stringr::str_to_title(df_all_words$devs)
  ## Limpando pontuações
  
  df_all_words$devs <- stringr::str_replace_all(df_all_words$devs, "[:punct:]", "")
  
  df_all_words
}
