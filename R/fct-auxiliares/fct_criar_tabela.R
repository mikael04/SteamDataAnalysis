########################################################################################## #
#' @name criar_tabela
#'  Função criada tabela para banco da steam (seguindo mesmo padrão de criar tabela Coorte)
#'   
#'  Autor: Mikael
#'  Data: 29/11/22
########################################################################################## #

# 0 - Scripts e bibliotecas ----
source("R/fct_get_colnames_df.R")

# 1 - Funçao ----
func_criar_tabela <- function(tabelao, debug){
  teste_interno <- F
  if(teste_interno){
    tabelao <- df_games_selected
    debug <- T
  }
  ## preciso ordernar as variáveis
  variaveis <- colnames(tabelao)[-c(1,2,3)]
  tabelas <- data.frame(nivel = integer(0), release_year = character(0), platform = integer(0), language = integer(0), n = numeric(0), variavel = character(0), stringsAsFactors = F)
  
  for(i in 1:length(variaveis)){
    if(T){
      print(paste0(round(100*i/length(variaveis)), "%"))
    }
    if(debug){
      print(paste0("Variavel = ", variaveis[[i]]))
    }
    
    colnames_tabelao <- func_get_colnames_df_unorder(tabelao)
    tabela <- tabelao |>  
      dplyr::group_by_at(.vars = c(variaveis[[i]], "release_year", "platform", "language")) |> 
      dplyr::tally() |> 
      dplyr::collect()
    names(tabela)[1] <- "nivel"
    tabela$variavel <- variaveis[[i]]
    
    tabelas <-  plyr::rbind.fill(tabelas, tabela)
  }
  tabelas
}
