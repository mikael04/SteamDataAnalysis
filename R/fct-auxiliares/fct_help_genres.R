#' help_genres 
#'
#' @description A function that will help with Genres manipulation
#' 1 - Get all unique values from a dataframe
#' 2 - clean developers names
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd

## Vai devolver todos os gêneros em um formato de lista, trazendo de um dataframe
## pulando a primeira coluna
func_get_all_genres <- function(dados){
  all_cols <- c("")
  len_dados <- length(dados)
  for(i in 2:len_dados){
    unique_col <- unique(dados[,i])
    all_cols <- unique(c(all_cols, unique_col))
  }
  all_cols[all_cols != ""]
}

## Função que irá fazer uma contagem em todo o DF pelo aparecimento de cada genero
## E retorna um df com o nome do gênero e sua contagem 
func_count_genres <- function(df){
  colnames_df <- colnames(df)
  df_counts <- as.data.frame(colnames_df[colnames_df != 'ID']) |> 
    dplyr::rename(genres = 1)
  df_counts$count <- NA
  for(i in 2:length(df)){
    df_counts[i-1, 2] <- sum(df[,i])
  }
  df_counts
}