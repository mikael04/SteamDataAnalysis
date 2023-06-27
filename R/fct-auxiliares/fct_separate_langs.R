########################################################################################## #
#'  Script/Função/módulo criado para ajustar linguagens de banco de dados da Steam, removendo
#'  caractéres inconsistentes, deixando a coluna pronta para ser separável por vírgula
#' 
#'  Autor: Mikael Marin Coletto
#'  Data: 25/02/2023
########################################################################################## #


## 0.1 - Bibliotecas e scripts fontes----


## 1.0 - Script/Função ----
func_separate_langs <- function(df, debug){
  ## Fazendo alterações para supported_languages ----
  df$language <- gsub('\\[', '', df$supported_languages)
  df$language <- gsub('\\]', '', df$language)
  df$language <- gsub("\\'", '', df$language)
  df$language <- gsub('\\"', '', df$language)
  df$language <- gsub('\\ ', '', df$language)
  df$language <- gsub('\\;', '', df$language)
  df$language <- gsub('b/b', '', df$language)
  df$language <- gsub('\\(fullaudio)', '', df$language)
  df$language <- gsub('\\\\r\\\\n', '', df$language)
  df$language <- gsub("&ampltstrong&ampgt&amplt/strong&ampgt", '', df$language)
  df$language <- gsub("&ampltbr/&ampgt&ampltbr/&ampgt", '', df$language)
  df$language <- gsub("\\(allwithfullaudiosupport)", '', df$language)
  df$language <- gsub("\\(textonly)", '', df$language)
  df$language <- gsub("#lang_français", 'French', df$language)
  df$language <- gsub("RussianEnglishSpanish-SpainFrenchJapaneseCzech", 
                               'Russian,English,Spanish-Spain,French,Japanese,Czech', df$language)
  df$language <- gsub("EnglishRussianSpanish-SpainJapaneseCzech", 
                               'English,Russian,Spanish-Spain,Japanese,Czech', df$language)
  df$language <- gsub("EnglishDutchEnglish", 
                               'English,Dutch', df$language)
}