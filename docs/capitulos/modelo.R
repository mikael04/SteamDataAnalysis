

# Helper packages
library(skimr)           # for variable summaries
library(tidymodels)      # for the recipes package, along with the rest of tidymodels

## Source functions
source("R/fct-auxiliares/fct_filter_top.R")
source("R/fct-auxiliares/fct_add_price_categ.R")
source("R/fct-auxiliares/fct_add_date_categ.R")


df_all_games <- data.table::fread(here::here("data-raw/created-tables/db-all-games-tags-all.csv"))

df_games_vars <- df_all_games |> 
  # dplyr::slice_sample(n = 1000) |> 
  dplyr::select(app_id, date_release, win, mac, linux, positive_ratio, price_original, steam_deck)

## Classificando variáveis
### 1 - o score de avaliação positiva para categorias
### 2 - Valores lógicos para numéricos (p/ serem convertidos)
### 3 - Data para categorias definidas (func_add_date_categ)
### 4 - Preço para categorias definidas (func_add_price_categ)

df_games_vars <- df_games_vars |> 
  dplyr::mutate(ratio = case_when(positive_ratio > 95 ~ "Excellent",
                                  positive_ratio > 85 ~ "Very Good",
                                  positive_ratio > 70 ~ "Not worth it",
                                  positive_ratio > 50 ~ "Ok",
                                  positive_ratio > 30 ~ "Bad",
                                  positive_ratio > 0 ~ "Very Bad",
                                  .default = "NoClass")) |> 
  dplyr::mutate(
    win = if_else(win, 1, 0),
    mac = if_else(mac, 1, 0),
    linux = if_else(linux, 1, 0),
    steam_deck = if_else(steam_deck, 1, 0),
  ) |> 
  func_add_date_categ(F) |> 
  func_add_price_categ(F) |> 
  dplyr::select(-date_release, -positive_ratio)


df_model <- df_games_vars

# Fix the random numbers by setting the seed 
# This enables the analysis to be reproducible when random numbers are used 
set.seed(222)
# Put 3/4 of the data into the training set 
data_split <- initial_split(df_model, prop = 3/4)

# Create data frames for the two sets:
train_data <- training(data_split)
test_data  <- testing(data_split)

steam_rec <- 
  recipe(ratio ~ ., data = train_data) |> 
  update_role(app_id, new_role = "ID") |>   
  step_dummy(date_categ, price_categ) #|>
  # step_date(date_release, features = c("dow", "month")) %>%               
  # step_holiday(date_release, 
  #              holidays = timeDate::listHolidays("US"), 
  #              keep_original_cols = FALSE)

summary(steam_rec)

lr_mod <- 
  multinom_reg() |> 
  set_engine("nnet") |> 
  set_mode("classification")

steam_wflow <- 
  workflow() %>% 
  add_model(lr_mod) %>% 
  add_recipe(steam_rec)

steam_fit <- 
  steam_wflow %>% 
  fit(data = train_data)

## Este formato de saída não pode ser colocado num DF, portanto não pode ser colocado numa tabela
# df_ <- steam_fit %>% 
#   extract_fit_parsnip() %>% 
#   tidy() |> 
#   DT::datatable()

predict(steam_fit, test_data)

steam_aug <- 
  augment(steam_fit, test_data)

# The data look like: 
steam_aug_tab <- steam_aug |> 
  select(ratio, app_id, .pred_class, .pred_Excellent, `.pred_Very Good`, `.pred_Not worth it`, 
         .pred_Ok , .pred_Bad, `.pred_Very Bad`)

steam_aug_tab_right <- steam_aug_tab |> 
  dplyr::mutate(pred_sucess = if_else(ratio == .pred_class, T, F)) |> 
  dplyr::select(app_id, pred_sucess, ratio, .pred_class)
