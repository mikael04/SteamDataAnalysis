func_teste_aux_desc_ggplot_df_csv <- function(df, variable, labels, racacor_idade, vars_recateg, vars_recateg_aval, show_na, debug) {
  teste_interno <- F
  if (teste_interno) {
    variable <- colnames_df[[1]][i]
    racacor_idade <- 2
    vars_recateg <- NULL
    show_na <- T
  }
  ### 2.1.1 Contagem de ano_entrada por categoria ----
  df_aux_ano_entrada <- df %>%
    # df_aux_ano <- df_teste_sample %>%
  dplyr::group_by(ano_entrada, !!as.name(variable)) %>%
    dplyr::summarise(count = n()) %>%
    dplyr::ungroup() %>%
    dplyr::collect() %>%
    dplyr::distinct(ano_entrada, !!as.name(variable), .keep_all = T)

  pass_check <- T
  ### Testando se rodaremos os códigos para a variável (ou se ela precisa ser alterada antes)
  tipos_problematicos <- c("character", "double")
  if (func_check_coltype(df_aux_ano_entrada, tipos_problematicos, debug = F)) {
    # browser()
    print(paste0("Essa variável não será analisada, pois precisa ser recategorizada por ser do tipo Character ou Date"))
    # vars_recateg <- append(vars_recateg, variable, length(vars_recateg)+1) vars_recateg_aval <- append(vars_recateg_aval, 'Variável do tipo character ou Data',
    # length(vars_recateg_aval)+1) next
    pass_check <- F
  }

  if (pass_check) {
    if (func_check_val_esp(df_aux_ano_entrada, 99, debug = F)) {
      # browser()
      print(paste0("Essa variável não será analisada, pois precisa ser recategorizada por causa do valor acima de 99"))
      # vars_recateg <- append(vars_recateg, variable, length(vars_recateg)+1) vars_recateg_aval <- append(vars_recateg_aval, 'Variável com valores acima de 99',
      # length(vars_recateg_aval)+1) next
    }

    df_aux_ano_entrada <- func_change_invalid(df_aux_ano_entrada, debug) %>%
      dplyr::rename(categoria = !!as.name(variable))

    ## alterando invalidas
    if (!show_na) {
      if (debug) {
        print("Não mostrar valores inválidos nas tabelas e gráficos")
      }
      df_aux_ano_entrada <- df_aux_ano_entrada %>%
        dplyr::filter(categoria != 99)
    }

    ## Por enquanto não vou adicionar as labels, pois daria muito trabalho fazer isso com todas as variáveis ## adicionando nomes de categorias labels_categ <- labels %>%
    ## dplyr::filter(variavel == variable) df_aux_ano_label <- dplyr::inner_join(labels_categ, df_aux_ano_entrada, by = c('nivel' = variable)) %>% dplyr::select(-nivel, -label_en,
    ## -variavel) %>% dplyr::rename(categoria = label) %>% dplyr::arrange(ano_entrada) %>% tidyr::pivot_wider(names_from = categoria, values_from = count) %>%
    ## dplyr::mutate(across(.cols = everything(), ~ ifelse(is.na(.x), 0, .x)))


    ### 2.1.2 Contagem de UF por categoria ----
    df_aux_uf <- df %>%
      # df_aux_ano <- df_teste_sample %>%
    dplyr::group_by(UF, !!as.name(variable)) %>%
      dplyr::summarise(count = n()) %>%
      dplyr::ungroup() %>%
      dplyr::collect() %>%
      dplyr::distinct(UF, !!as.name(variable), .keep_all = T)

    df_aux_uf <- func_return_estado(df_aux_uf, debug = F) %>%
      dplyr::rename(categoria = !!as.name(variable)) %>%
      dplyr::select(-UF) %>%
      dplyr::select(UF = UF_aux, categoria, count) %>%
      dplyr::filter(UF != "90")

    ## alterando invalidas
    df_aux_uf <- func_change_invalid(df_aux_uf, debug)

    ## Por enquanto não vou adicionar as labels, pois daria muito trabalho fazer isso com todas as variáveis ## adicionando nomes de categorias df_aux_uf_label <-
    ## dplyr::inner_join(labels_categ, df_aux_uf, by = c('nivel' = variable)) %>% dplyr::select(-nivel, -label_en, -variavel) %>% dplyr::rename(categoria = label)

    if (!show_na) {
      df_aux_uf <- df_aux_uf %>%
        dplyr::filter(categoria != 99)
    }

    ## função para racacor if(racacor_idade == 1 || racacor_idade == 2){ 2.1.3 Contagem de racacor por categoria ----
    df_aux_racacor <- df %>%
      # df_aux_ano <- df_teste_sample %>%
    dplyr::group_by(racacor_sinasc, !!as.name(variable)) %>%
      dplyr::summarise(count = n()) %>%
      dplyr::ungroup() %>%
      dplyr::collect() %>%
      dplyr::distinct(racacor_sinasc, !!as.name(variable), .keep_all = T)

    ## alterando invalidas
    df_aux_racacor <- func_change_invalid(df_aux_racacor, debug) %>%
      dplyr::rename(categoria = !!as.name(variable))

    ## Por enquanto não vou adicionar as labels, pois daria muito trabalho fazer isso com todas as variáveis ## adicionando nomes de categorias df_aux_racacor_label <-
    ## dplyr::inner_join(labels_categ, df_aux_racacor, by = c('nivel' = variable)) %>% dplyr::select(-nivel, -label_en, -variavel) %>% dplyr::rename(categoria = label)


    if (!show_na) {
      df_aux_racacor <- df_aux_racacor %>%
        dplyr::filter(categoria != 99)
    }

    if (racacor_idade == 1) {
      df_aux_idade <- NULL
    }
    # } função de idade, ainda não desenvolvida if(racacor_idade == 0 || racacor_idade == 2){ 2.1.4 Contagem de idade por categoria ----
    df_aux_idade <- df %>%
      # df_aux_ano <- df_teste_sample %>%
    dplyr::group_by(idademae, !!as.name(variable)) %>%
      dplyr::summarise(count = n()) %>%
      dplyr::ungroup() %>%
      dplyr::collect() %>%
      dplyr::distinct(idademae, !!as.name(variable), .keep_all = T)

    ## alterando invalidas
    df_aux_idade <- func_change_invalid(df_aux_idade, debug) %>%
      dplyr::rename(categoria = !!as.name(variable))

    ## Por enquanto não vou adicionar as labels, pois daria muito trabalho fazer isso com todas as variáveis ## adicionando nomes de categorias df_aux_idade_label <-
    ## dplyr::inner_join(labels_categ, df_aux_idade, by = c('nivel' = variable)) %>% dplyr::select(-nivel, -label_en, -variavel) %>% dplyr::rename(categoria = label)

    if (!show_na) {
      df_aux_idade <- df_aux_idade %>%
        dplyr::filter(categoria != 99)
    }

    if (racacor_idade == 0) {
      df_aux_racacor <- NULL
    }
    # }
  } else {
    df_aux_ano_entrada <- NULL
    df_aux_idade <- NULL
    df_aux_racacor <- NULL
    df_aux_uf <- NULL
  }
  list(df_aux_ano_entrada, df_aux_idade, df_aux_racacor, df_aux_uf, pass_check)
  # list(df_aux_ano_entrada, df_aux_idade, df_aux_racacor, df_aux_uf, vars_recateg, vars_recateg_aval)
}
