########################################################################################## #
#' Funcoes para receber nomes de variaveis (colunas em df, unique nas tabelas)
#'   
#'  Autor: Mikael
#'  Data: 29/11/22
########################################################################################## #

# 0 - Scripts e bibliotecas ----
# 1. Funcao ----

func_get_colnames_df <- function(df){
  col_names <- colnames(df)
  col_names |>
    as.data.frame() |>
    arrange(col_names)
}

func_get_colnames_df_unorder <- function(df){
  col_names <- colnames(df)
  col_names |>
    as.data.frame()
}

func_get_colnames_tabela <- function(tabela){
  # tabela <- tabela_CADU_pt1
  unique(tabela$variavel)
}
