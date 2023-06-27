############################################################################################ #
#'  Script criado para analisar os dados da steam
#' 
#'  Autor: Mikael
#'  Data: 13/08/22
############################################################################################ #

# 0. Bibliotecas ----
library(dplyr)
library(data.table)
library(dtplyr)

source("R/fct-auxiliares/fct_help_genres.R")
source("R/fct-auxiliares/fct_help_dev_names.R")

# 1. Dados de generos ----
dados <- read.table("data-raw/steam-data/db-0/applicationGenres.csv", col.names = paste("V",1:25), fill = T, sep = ",")
dados <- dados[,which(!is.na(dados[1,]))]

## 1.1.1 Organizando os nomes das colunas
colnames(dados) <- c("ID", "Categoria1", "Categoria2", "Categoria3", "Categoria4",
                     "Categoria5", "Categoria6", "Categoria7", "Categoria8")

## Vetor com todos os generos que aparecem na tabela

all_genres <- sort(func_get_all_genres(dados))

## Criando novo DF, no formato de uma coluna para cada gênero
df <- dados |> 
  dplyr::select(ID)

df[all_genres] <- NA

for(i in 1:length(all_genres)){
  check <- F
  for(j in 1:nrow(df)){
    if(all_genres[i] %in% dados[j,]){
      df[j,i+1] = T
    }else{
      df[j,i+1] = F
    }
  }
}

## Escrevendo novo dataframe
# data.table::fwrite(df, "data-raw/generos_tratados.csv")

## 1.1. Tabela de contagens para cada gênero ----
df_counts <- func_count_genres(df)

## Gráfico de barras com os 10 gêneros que mais aparecem
df_counts_top10 <- df_counts |> 
  dplyr::arrange(desc(count)) |> 
  dplyr::slice_head(n = 10) |> 
  tidyr::pivot_wider(names_from = genres, values_from = count)

df_counts_top10 <- df_counts |> 
  dplyr::arrange(desc(count)) |> 
  dplyr::slice_head(n = 10)


### 1.1.1. Gráfico top10 gêneros ----
library(ggplot2)

fig_top10 <- ggplot(df_counts_top10, aes(x = count, y = genres)) +
  geom_col() +
  theme_minimal()
fig_top10

df_counts_last10 <- df_counts |> 
  dplyr::arrange(count) |> 
  dplyr::slice_head(n = 10)

## 1.2. Dois gêneros mais vistos em conjunto ----

df_sample <- df |> 
  dplyr::sample_n(size = 30)

# sum(df_sample[, "Action"] & df_sample[,4] == T)
# sum(df_double)
# df_sample[,3] == T
# df_sample[,4] == T
# df_sample[,2]

top10_genres <- df_counts_top10 |> 
  dplyr::select(genres) |> 
  dplyr::pull()


## Criando dfs base para contagem de comparativo
df_comp<- data.frame(matrix(ncol = 2, nrow = 0))
colnames(df_comp) <- c("genres", "count")
k <- 1
for(i in 1:length(top10_genres)){
  print(paste0("Comecando a buscar duplas no genero ", top10_genres[i]))
  for(j in 2:(ncol(df)-1)){
    print(paste0("Comparando com o genero ", all_genres[j]))
    if(all_genres[j] != top10_genres[i]){
      print(paste0("i = ", i))
      print(paste0("j = ", j))
      count <- sum(df[, i] & df[,j] == T)
      this_comp <- c(paste0(top10_genres[i], " & ", all_genres[j]), count)
      df_comp[k, ] = this_comp
      k=k+1
    }
  }
}

df_comp[,2] = as.numeric(df_comp[,2])


df_duplas_top10 <- df_comp |> 
  dplyr::arrange(desc(count)) |> 
  dplyr::slice_head(n = 10)

### 1.2.1. Gráfico top10 dois gêneros agrupados ----

fig_top10_dup <- ggplot(df_duplas_top10, aes(x = count, y = reorder(genres, count))) +
  geom_col() +
  theme_minimal()
fig_top10_dup

rm(list=ls())

# 2. Dados de desenvolvedores ----

## Organizando nomes
df_devs <- func_organ_names(NULL, T)
df_devs <- func_clean_dev_names(df_devs)

library(dplyr)
df_all_devs_count <- df_devs |> 
  dplyr::group_by(devs) |> 
  dplyr::summarize(count = dplyr::n()) |> 
  dplyr::ungroup() |> 
  dplyr::arrange(desc(count)) |> 
  dplyr::slice_head(n = 100)

library(ggplot2)
fig_top10_dev <- ggplot(df_all_devs_count, aes(x = count, y = reorder(devs, count))) +
  geom_col() +
  theme_minimal()
fig_top10_dev

# 
# vetor_ex <- c("2K Australia", "2K Boston", "2K China", "Alexey Bokulev", "Alexey Davydov", "CAPCOM CO LTD", "Capcom Game Studio Vancouver", "Capcom Game Studio Vancouver Inc")
# 
# c("2K", "2K", "2K", "Alexey Bokulev", "Alexey Davydov", "CAPCOM", "Capcom", "Capcom")

# 3. Dados de nova base (dados de jogos) ----
## https://www.kaggle.com/datasets/fronkongames/steam-games-dataset

## Lendo tabelas csv
df_games <- data.table::fread("data-raw/steam-data/db-1/games.csv", sep = ',')

# ## Lendo tabela json
# json_list <- jsonlite::read_json("data-raw/steam-data/db-1/games.json")
# 
# ## Organizando json em formato dataframe
# df_json_df <- tidyr::as_tibble(json_list)
# 
# rownames_json <- c("ID", names(df_json_df$`20200`))
# 
# df_games_json <- df_json_df |> 
#   dplyr::as_tibble() |> 
#   tibble::rownames_to_column() |>   
#   tidyr::pivot_longer(-rowname) |>  
#   tidyr::pivot_wider(names_from=rowname, values_from=value)  |> 
#   dplyr::mutate(across(everything(), as.character)) |> 
#   magrittr::set_colnames(rownames_json)
# 
# ## Comparando tabelas
# json_cols <- stringr::str_sort(rownames_json)
# csv_cols <- stringr::str_sort(names(df))
# 
# l <- tibble::lst(json_cols, csv_cols)
# cols_compare <- data.frame(lapply(l, `length<-`, max(lengths(l))))
# 
# detail_descrip <- as.character(df_games_json[1,7])
# about <- as.character(df_games_json[1,8])
# short_descrip <- as.character(df_games_json[1,9])

## Após a análise exploratória, foi visto que não precisamos dos dados de descrição extras presentes no arquivo json, usaremos então o df no formato csv
## Caso queiramos uma descrição resumida, podemos pegar do arquivo json através da coluna short_description

# df_games <- data.table::fread("data-raw/steam-data/db-1/games.csv", sep = ',')
df_games$Release.date <- lubridate::mdy(df_games$`Release date`)

## Colunas que podem ser interessantes:

## Dashboard --
## Data (fazer um gráfico de lançamento por mês, avaliar lançamentos por ano, comparar lançamentos nos anos)
## Mostrar jogos de acordo com linguagem escolhida (supported + full audio)
## Trazer um resumo do jogo ao clicar nele (imagem, data de lançamento, preço, número de jogadores,
## pico de jogadores no último dia, linguagens, plataformas Win,Lin,Mac, metacritic score, userscore, votos positivos e negativos)

## Análise --
## Pico de usuários (comparar com jogos free ou não)
## Preço, fazer um comparativo de preços, comparativo de preços médio por ano, verificar número de jogadores
## Analise de requerimento de idade para jogos
## Analisar idiomas mais usados (supported, legenda e full audio, dublagem)


## 3.0 Dados gerais da base (atualizados base 2022) ----
summary(df_games)

## Checando se o ID é único
dplyr::n_distinct((df_games$AppID))
## Sim, é único

df_games_ano <- df_games |> 
  dplyr::select(AppID, Name, `Estimated owners`, `Price`, `Release date`, Release.date)

## 3.1. Exploração de filtros ----
### 3.1.1. Ano de lançamento ----

summary(df_games$Release.date)

skimr::skim(df_games$Release.date)

max(df_games$`Release date`)
max(df_games$`Release.date`)

df_games_ano <- data.table::setDT(df_games_ano)[, Release_Yr := format(as.Date(Release.date), "%Y") ]

### 3.1.2. Linguagens suportadas (Supported Languages) ----

summary(df_games$`Supported languages`)

skimr::skim(df_games$`Supported languages`)

df_games_language <- as.data.frame(df_games[, `Supported languages`]) |> 
  dplyr::rename(Sup_languages = 1)

df_games_language$language <- gsub('\\[', '', df_games_language$Sup_languages)
df_games_language$language <- gsub('\\]', '', df_games_language$language)
df_games_language$language <- gsub("\\'", '', df_games_language$language)
df_games_language$language <- gsub('\\"', '', df_games_language$language)

## Corrigindo idioma de jogo problemático
df_games[63064, ]

## Kaboom! Corrigido
df_games[62736, 10] <- "'All languages'"
df_games_language[62736, 2] <- "'All languages'"

## Cube Loop alterado
df_games[63064, 10] <- "'All languages'"
df_games_language[63064, 2] <- "'All languages'"

## Separa em df de mais de um elemento quando possui mais de um país
# nmax <- max(stringr::str_count(df_games_language$language, "\\,")) + 1
# nmax <- max(stringr::str_count(df_games_language$Sup_languages, "\\,")) + 1
nmax <- 1
for(i in 1:nrow(df_games_language)){
  max_line <- max(stringr::str_count(df_games_language[i, 2], "\\,")) + 1
  if(max_line > nmax){
    nmax <- max_line
    nmax_line <- i
  }
}
## Analisando inconsistências
# stringr::str_count(df_games_language[62736, 2], "\\,")

df_games_language_split <- df_games_language %>%
  dplyr::select(language) |> 
  tidyr::separate(language, into=paste0("idioma_", seq_len(nmax)), sep =  '\\,', fill = "right")

## Analisando número de agrupamentos distintos

n_distinct(df_games_language$language)

### 3.1.3. Plataforma suportada (oficialmente) ----

df_games_so <- df_games |> 
  dplyr::select(AppID, Windows, Mac, Linux)

# win_count <- sum(df_games_so$Windows)
# mac_count <- sum(df_games_so$Mac)
# lin_count <- sum(df_games_so$Linux)

## 3.2 Exploração inicial de variáveis ----

colnames_df_games <- as.data.frame(colnames(df_games))

### 3.2.1. Categorias (atualizados base 2022) ----

df_categ <- as.data.frame(df_games$Categories)
colnames(df_categ) <- "Categories"

## Separando a coluna pelo separador ','
df_categ_org <- df_categ |> 
  dplyr::mutate(Categories = strsplit(Categories, ","))

## Separando a coluna pelo separador ','
df_categ_org <- df_categ |> 
  dplyr::mutate(Categories = strsplit(Categories, ","))

## Dessa forma consigo a contagem mais rapidamente

# max(lengths(df_categ_org$Categories))
df_categ_org_count <- df_categ_org |>  
  tidyr::unnest(Categories) |>
  dplyr::group_by(Categories) |> 
  dplyr::summarise(count = dplyr::n()) |> 
  dplyr::ungroup()

### 3.2.2. Generos (atualizados base 2022) ----
df_generos <- as.data.frame(df_games$Genres)
colnames(df_generos) <- "Genres"

## Separando a coluna pelo separador ','
df_generos_org <- df_generos |> 
  dplyr::mutate(Genres = strsplit(Genres, ","))

## Dessa forma consigo a contagem mais rapidamente

# max(lengths(df_generos_org$Genres))
df_generos_org_count <- df_generos_org |>  
  tidyr::unnest(Genres) |>
  dplyr::group_by(Genres) |> 
  dplyr::summarise(count = dplyr::n()) |> 
  dplyr::ungroup()


### 3.2.3. Precos (Price) ----
df_games_price <- df_games |> 
  dplyr::select(AppID, Name, `Peak CCU`, Price, Categories, Genres, Tags) |> 
  # dplyr::slice_sample(n = 1000) |> 
  dplyr::filter()

nrow(df_games_price[df_games_price$Categories == "", ])
## 1738 linhas em branco
nrow(df_games_price[df_games_price$Genres == "", ])
## 2646 linhas em branco
nrow(df_games_price[df_games_price$Tags == "", ])
## 8929 linhas em branco

## Removendo os utilitários (programas)

df_games_price <- df_games_price |> 
  dplyr::filter(!dplyr::if_any(everything(), ~ stringr::str_detect(., pattern = "Utilit"))) |>
  dplyr::mutate(Price_numb = as.numeric(Price))

df_games_price <- df_games_price |> 
  dplyr::filter(!dplyr::if_any(everything(), ~ stringr::str_detect(., pattern = "Video Production"))) |> 
  dplyr::filter(!dplyr::if_any(everything(), ~ stringr::str_detect(., pattern = "Modeling")))

df_games_sim <- df_games_price |> 
  dplyr::filter(stringr::str_detect(Genres, pattern = "Simulation"))

## Testando se o número de unnest estava correto
# sum = 0
# for(i in 1:nrow(df_generos_org)){
#   # if(is.integer(df_generos_org[1,i]) && length(df_generos_org[i,1]) == 0)
#   sum = sum + lengths(df_generos_org[i,1])
# }
# 
# ## Para dar certo precisaria que todas as linhas possuíssem o mesmo número de elementos
# df_gen_aux <- cbind(df_generos_org_test[1], t(data.frame(df_generos_org_test$Genres)))
# 
## Forma muito mais lenta, mas que faz automaticamente
## Precisaria adaptar a saída, além de que demorou tanto tempo que o sistema finalizou o processo (mais de algumas horas, vou manter o uso da versão acima)
# 
# df_generos_un <- df_generos_org_test |>
#   tidyr::unnest_wider(Genres)
# 
# df_generos_org_count_test <- df_generos_org_test |>  
#   tidyr::unnest(Genres) |>
#   dplyr::group_by(Genres) |> 
#   dplyr::summarise(count = dplyr::n()) |> 
#   dplyr::ungroup()

## Como fazer a seleção por idioma, se um jogo pode ter mais de 29 idiomas
## um simples %in% resolveria dentro de um shiny? -- PERFORMANCE

### 3.2.4. Número de jogadores estimados ----

summary(df_games$`Estimated owners`)
skimr::skim(df_games$`Estimated owners`)

## Quantidade de categorias
dplyr::n_distinct(df_games$`Estimated owners`)
## Categorias
unique(df_games$`Estimated owners`)

### 3.2.X. Idade recomendada (Required Age) ----

### Pelo summary geral já pude visualizar esse não é um dado bem preenchido

summary(df_games$`Required age`)

# Min.    1st Qu.  Median  Mean    3rd Qu. Max. 
# 0.0000  0.0000   0.0000  0.3624  0.0000  21.0000 

## 4.0 Análise do MongoDB ----

vars <- mongo_db$distinct("variavel")
years <- mongo_db$distinct("release_year")
languages <- mongo_db$distinct("language")


# Análises ----
## Melhor escolha, primeiro fazer apenas todas as colunas interessantes como variáveis
### depois posso pensar em adicionar filtros e começar a traçar análises mais profundas 
### (contagens de combinações interessantes como Ano, faixa de preço, gênero, categoria)
### a princípio filtros que parecem interessantes:
### - 3.1.1 - ano de lançamento - OK - FILTRO
### - 3.1.1.1 - Alguma análise sobre o mês?
### - 3.1.2 - idioma suportado ** - OK - 29 idiomas, vai ser FILTRO , pelo formato (mais de uma por categoria)
### - 3.1.3 - plataforma (win, mac, linux) - OK - FILTRO
### - 3.2.1 - categorias - OK - 36 categorias
### - 3.2.3 - gêneros - OK - 33 gêneros,  muitas categorias, será uma visualização, porém reagrupada
### - 3.2.4 - preço - OK - Pode ser um filtro, de $9 até $34 - recategorizar, apresentar dado
### - 3.2.x - idade recomendada - ANALISADA - Não há dados para criar gráficos, pouco preenchimento fora de 0

### Adicionais
### Versões de outros idiomas podem usar uma tradução de preço também, 
### conforme moeda que o steam usa.

### Adicionar uma opção para ver os gráficos de forma absoluta ou relativa

### Possivelmente usar como filtro idioma em dummys (ao invés de uma caixa de texto como está agora)

#### **Variáveis com mais de uma categoria por coluna teriam muito problema de processamento
#### Farei um teste com idioma, criando diferentes bancos para cada idioma
#### poderia dividir em novas colunas (estilo dummy, que provavelmente aumentaria muito o tamanho do banco e o tempo de criação dele)
#### ou fazer a contagem posterior no shiny agrupando em tempo de execução (provavelmente lento)