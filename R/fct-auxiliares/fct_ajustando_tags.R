########################################################################################## #
#'  Script/Função/módulo criado para
#' 
#'  Autor: Mikael Marin Coletto
#'  Data: 
########################################################################################## #


## 0.1 - Bibliotecas e scripts fontes----


## 1.0 - Script/Função ----
func_ajustando_tags <- function(df_diff, debug){
  ## Tags que serão ajustadas na primeira coluna (first)
  pattern_first <- c("1 - ", "Roguelike", "Roguelite", "Base Building", "Football \\(Soccer\\)",
                     "Football (American)", "Puzzle Platformer")
  ## Tags de substituição
  replacement_first <- c("", "Rogue-like", "Rogue-lite", "Base-Building", "Soccer", "Football",
                         "Puzzle-Platformer")
  ## Tags que serão ajustadas na primeira coluna (first)
  pattern_seccond <- c("2 - ", "e-sport")
  ## Tags de substituição
  replacement_seccond <- c("", "eSport")
  
  # word <- "Football (Soccer)"
  # stringi::stri_replace_all_regex(word, "Football \\(Soccer\\)", "Soccer")
  
  df_diff <- df_diff |> 
    dplyr::mutate(first = stringi::stri_replace_all_regex(first, pattern_first, replacement_first, vectorize_all = F)) |> 
    dplyr::mutate(seccond = stringi::stri_replace_all_regex(seccond, pattern_seccond, replacement_seccond, vectorize_all = F)) |> 
    dplyr::rowwise() |> 
    dplyr::mutate(add_tags = paste0(dplyr::union(first, seccond), collapse = ",")) |> 
    dplyr::mutate(add_tags = stringi::stri_replace_all_regex(add_tags, "^,|,$", "", vectorize_all = F))
  
  #### XXXXXXXX ####
  ## Tratar palavras que foram substituídas, mas foram adicionadas em duplicata pelo número de strings
  #### XXXXXXXX ####
  library(tidyr)
  df_diff <- df_diff |> 
    tidyr::separate_longer_delim(add_tags, delim = ",") |> 
    # tidyr::separate_rows(equal, sep = ",") # |> 
    dplyr::distinct(id, add_tags, .keep_all = T) |> 
    # dplyr::arrange(id, add_tags) |> 
    dplyr::group_by(id) |> 
    dplyr::mutate(diff_tags = paste0(add_tags, collapse = ",")) |> 
    dplyr::distinct(id, diff_tags, .keep_all = T) |> 
    dplyr::ungroup() |> 
    dplyr::select(id, equal, diff_tags)
  
  df_diff <- df_diff |>
    dplyr::mutate(all_tags = paste0(equal, if_else(diff_tags == "",  "", paste0(",", diff_tags)))) |>
    tidyr::separate_longer_delim(all_tags, delim = ",") |> 
    dplyr::arrange(id, all_tags) |>
    dplyr::group_by(id) |> 
    dplyr::mutate(tags = paste0(all_tags, collapse = ",")) |> 
    dplyr::distinct(id, tags, .keep_all = T)|> 
    dplyr::ungroup() |> 
    dplyr::select(id, tags)
  
  df_diff
}