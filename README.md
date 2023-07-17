
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Análise de dados da Steam

<!-- badges: start -->

![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)
![RStudio](https://img.shields.io/badge/RStudio-4285F4?style=for-the-badge&logo=rstudio&logoColor=white)
![Steam](https://img.shields.io/badge/steam-%23000000.svg?style=for-the-badge&logo=steam&logoColor=white)

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

Este projeto foi criado para estudo pessoal, aproveitando um tema que eu
gosto bastante, o mercado de jogos.

## Relatório

O relatório deste projeto pode ser encontrado em: [GitHub Pages -
SteamDataAnalysis](https://mikael04.github.io/SteamDataAnalysis/).

## Introdução

O intuito desta análise é ilustrar os conhecimentos adquiridos em R,
começando com uma análise exploratória dos dados e tentando trazer
alguns insights relacionados à jogos de sucesso no mercado. Para isso
vou passar pelas etapas de elaboração do objetivo, trabalho no
tratamento e limpeza dos dados, fazer análises de variáveis de interesse
individualmente e depois cruzando algumas delas para tentar traçar
algumas conclusões, que, por fim, podem sugerir alguns caminhos para
empresas que pretendem lançar seus jogos terem sucesso na Steam.

## Os dados

Todas as bases de dados utilizadas foram extraídas do Kaggle e já
possuíam algum tratamento, apesar de ainda ser necessário alguns
ajustes. São fontes que possuem dados extraídos pela API da Steam, em
alguns casos de forma sazonal, contendo diferentes informações sobre os
jogos.

Uma breve descrição e os links para download destas bases de dados podem
ser encontradas no arquivo *data-raw/steam-data/DBs-README.md*. Caso
queira reproduzir este relatório, consultar os arquivos
“*lista-arquivos.txt*” presentes em cada pasta. Os arquivos não serão
incluídos neste projeto devido ao seus tamanhos em alguns casos
excederem o permitido pelo GitHub.

## Metodologia

Para esta análise exploratória, inicialmente investiguei algumas
variáveis relacionadas às avaliações, em diferentes bases de dados. Em
seguida, fiz a análise descritiva destas variáveis, de variáveis
relacionadas às categorias, gêneros e tags dos jogos, que são formas de
classificar os jogos. E por fim, trabalhei com uma an análise bivariada
entre a variável de preço e as variáveis de avaliação dos jogos.

Para ilustração foram utilizadas tabelas com métricas de tendência
central, além de histogramas, boxplots e gráficos de barras para
apresentação dos dados.

A ferramenta utilizada para análises foi a linguagem R (*v. 4.1.2*) e o
RStudio (*v. 2026.06.0)*. As principais bibliotecas utilizadas foram:
*dplyr, gt, ggplot2, quarto, stringr, here, purrr, jsonlite e
data.table.*

## Resultados

Após a execução das análises iniciais das variáveis individualmente
observei que os dados não pareciam mostrar nenhum tipo de comportamento
relevante, não consegui traçar nenhuma conclusão diretamente.

Então decidii começar a trabalhar com a análise dos preços e relacionar
ela com as categorias dos jogos, além de filtrar por notas ou número de
avaliações positivas. Essas combinações já se mostraram mais
interessantes, apesar de ainda termos uma distribuição bastante
heterogênea, analisando os jogos pude levantar algumas hipóteses, elas
são descritas em mais detalhes no relatório final deste projeto.

## Conclusão

Apesar de ser uma análise descritiva simples, foi possível traçar
algumas conclusões interessantes relacionando às avaliações positivas ou
o score de avaliação, os preços e as categoria dos jogos.  
Por fim, é possível verificar que parece existir alguns comportamentos
em jogos de sucesso dependendo da sua faixa de preço, que pode ser
bastante útil para futuros criadores de jogos ou estúdios.

O relatório entregue utiliza ferramentas gráficas que facilitam a
visualização e compreensão das análises, além de formas de destaque no
relatório em pontos chaves para o entendimento da mensagem transmitida.

Este relatório também foi pensado de forma a ser reprodutível, e
atualizável com novos dados conforme novos jogos forem sendo lançados,
desde que, é claro, as conclusões e análises sejam revistas para
observarem se os comportamentos observados se mantém ou divergem no
futuro.

Como prova de uso das ferramentas, também se provou bastante
interessante, alguns percalços foram transpostos, principalmente nos
pontos comumente problemáticos de uma análise de dados, que é a
validação da base de dados e a união de diferentes bases, ainda que de
mesmo assunto, mas em formatos diferentes.

### No horizonte

Eu gostaria de já ter incluído alguns pontos nesta análise inicial,
porém, para que não fosse um projeto tão longo e para que já tivesse uma
entrega inicial, eles foram deixados de lado como adições futuras. São
elas:

- ~~Publicar utilizando o GitHub Pages.~~ Já feito para esta versão;

- ~~Uso de um banco de dados: Já existe um arquivo e já foi feita uma
  conexão com um banco de dados MongoDB, porém inicialmente pela
  praticidade foi optado por utilizar arquivos nos formatos .csv e
  .json..~~ O relatório foi alterado para utilizar o SQLite, buscando e salvando novas bases de dados nele;

- Criar documentação resumida.

- Criar um relatório resumido ou uma apresentação: Para facilitar a
  compreensão, foi pensada numa apresentação de resumo deste relatório
  entregue, que será feita no futuro.

- Complementar algumas análises, principalmente referente aos jogos mais
  bem avaliados.

- Tentar desenvolver algum modelo mais robusto para a análise destas
  categorias: Neste ponto o problema mais complexo seria ajustar uma
  única base de dados, visto que as duas utilizadas diferem bastante em
  suas *features* disponíveis.

## 

## Extras

Gostaria de deixar também por escrito que todas as análises aqui foram
feitas com âmbito de estudo e devem ser estudadas com cautela.

E fico também aberto à críticas (construtivas, por favor), dúvidas ou
qualquer outra mensagem através do e-mail:
**mikael.coletto.eng@gmail.com**.

A análise segue os padrões de código aberto, só peço que se for utilizar
partes ou mesmo todo o conteúdo, que cite este projeto aberto para os
devidos créditos.
