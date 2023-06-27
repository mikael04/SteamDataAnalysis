########################################################################################## #
#' @name manip_vars
#' Função criada manipular banco de dados, retornando banco pronto para contagem
#'   
#'  Autor: Mikael
#'  Data: 29/11/22
########################################################################################## #

# 0 - Scripts e bibliotecas ----
library(dplyr)
# library(data.table)
# library(dtplyr)
# source("R/fct_get_colnames_df.R")
source("R/fct_clean_names.R")
source("R/fct_criar_tabela.R")

# 1 - Funçao ----
func_manip_vars <- function(df, debug){
  teste_interno <- F
  if(teste_interno){
    df <- df_games
    debug <- T
  }
  ## Padronizando nomes ----
  df <- func_clean_names(df, debug)
  
  ## Selecionando variávies que serão utilizadas ----
  df_selected <- df |> 
    dplyr::select(appid, name, release_date, estimated_owners, price, supported_languages,
                  windows, mac, linux, categories, genres)
  
  ## Ajustando o ano ----
  df_selected <- df_selected |> 
    # dplyr::mutate(release_year = format(as.Date(release_date), "%Y"))
    dplyr::mutate(release_year = sub('.*(?=.{4}$)', '', release_date, perl=T))
  
  ## Ajustando as plataformas ----
  df_selected <- df_selected |> 
    dplyr::mutate(platform = linux*100 + mac*10 + windows)
  
  ## Fazendo alterações para supported_languages ----
  df_selected$language <- gsub('\\[', '', df_selected$supported_languages)
  df_selected$language <- gsub('\\]', '', df_selected$language)
  df_selected$language <- gsub("\\'", '', df_selected$language)
  df_selected$language <- gsub('\\"', '', df_selected$language)
  df_selected$language <- gsub('\\ ', '', df_selected$language)
  df_selected$language <- gsub('\\;', '', df_selected$language)
  df_selected$language <- gsub('b/b', '', df_selected$language)
  df_selected$language <- gsub('\\(fullaudio)', '', df_selected$language)
  df_selected$language <- gsub('\\\\r\\\\n', '', df_selected$language)
  df_selected$language <- gsub("&ampltstrong&ampgt&amplt/strong&ampgt", '', df_selected$language)
  df_selected$language <- gsub("&ampltbr/&ampgt&ampltbr/&ampgt", '', df_selected$language)
  df_selected$language <- gsub("\\(allwithfullaudiosupport)", '', df_selected$language)
  df_selected$language <- gsub("\\(textonly)", '', df_selected$language)
  df_selected$language <- gsub("#lang_français", 'French', df_selected$language)
  df_selected$language <- gsub("RussianEnglishSpanish-SpainFrenchJapaneseCzech", 
                       'Russian,English,Spanish-Spain,French,Japanese,Czech', df_selected$language)
  df_selected$language <- gsub("EnglishRussianSpanish-SpainJapaneseCzech", 
                       'English,Russian,Spanish-Spain,Japanese,Czech', df_selected$language)
  df_selected$language <- gsub("EnglishDutchEnglish", 
                               'English,Dutch', df_selected$language)
  
  ## Tratando de inconsistências nas linguagens ----
  
  
  ## Separando linhas com mais de um valor (separando em linhas) ----
  ## Colunas supported_languages, categories, genres
  df_selected <- df_selected |>
    dplyr::filter(!language == "" )|> 
    tidyr::separate_rows(language, sep = ",") |> 
    tidyr::separate_rows(categories, sep = ",") |> 
    tidyr::separate_rows(genres, sep = ",")
  
  ## Selecionando colunas e retornando df ----
  df_selected |> 
    dplyr::select(release_year, platform, language, estimated_owners, price, categories, genres)
  
}
