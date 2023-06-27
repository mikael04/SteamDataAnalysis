########################################################################################## #
#'  Função criada para limpar nomes de banco de dados, padronizando
#'
#'   
#'  Autor: Mikael
#'  Data: 29/11/22
########################################################################################## #

# 0 - Scripts e bibliotecas ----

# 1 - Funçao ----
func_clean_names <- function(df, debug){
  if(debug){
    print("Before cleaning names")
    print(names(df))
  }
  names(df) <- names(df) |> 
    tolower() |> 
    gsub(pattern = "\\s+", replacement = "_") |> 
    iconv(to = "ASCII//TRANSLIT")
  
  if(debug){
    print("After cleaning names")
    print(names(df))
  }
  df
}