#' order_strings 
#'
#' @description A fct function that receive a string vector organize and return it
#'
#' @return A string vector organized
#' 
#' @details
#' We receive a string vector, separated by comma, and split it up by commas too.
#' 
#'
#' @noRd

function_order_strings <- function(string_vector){
  # teste_interno <- F
  # if(teste_interno){
  #   string_vector <- "Anime,Dating Sim,Female Protagonist,Otome,Romance,Simulation,Singleplayer,Story Rich,Visual Novel,Choices Matter"
  # }
  all_ordered <- string_vector |> 
    purrr::map(\(x) stringr::str_sort(stringr::str_split_1(x, pattern = ",")))
  
  all_ordered <- paste0(unlist(all_ordered), collapse = ",")
  all_ordered
}