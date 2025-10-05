# Pacotes
req <- c("data.table","dplyr")
to_install <- setdiff(req, rownames(installed.packages()))
if (length(to_install)) install.packages(to_install, repos = "https://cloud.r-project.org")
library(data.table); library(dplyr)

#Entrada de dados
CSV_LOCAL <- "estimativa_pop_idade_sexo_esp.csv"
ZIP_URL   <- "https://github.com/DaianneS/Trabalho005PI/blob/main/estimativa_pop_idade_sexo_esp.zip?raw=1"

if (file.exists(CSV_LOCAL)) {
  dados <- fread(CSV_LOCAL, encoding = "UTF-8")
} else {
  tmp_zip <- tempfile(fileext = ".zip")
  download.file(ZIP_URL, tmp_zip, mode = "wb")
  lst <- unzip(tmp_zip, list = TRUE)$Name
  csv_int <- lst[grepl("\\.csv$", lst, ignore.case = TRUE)][1]
  unzip(tmp_zip, files = csv_int, exdir = tempdir(), overwrite = TRUE)
  dados <- fread(file.path(tempdir(), csv_int), encoding = "UTF-8")
}

#Normalização mínima
names(dados) <- gsub("\\s+","_", tolower(names(dados)))
if ("ano" %in% names(dados)) dados$ano <- suppressWarnings(as.integer(dados$ano))
if ("populacao" %in% names(dados)) {
  dados$populacao <- suppressWarnings(as.numeric(gsub("\\.", "", gsub(",", ".", as.character(dados$populacao)))))
}
rm_acento_lower <- function(x) tolower(iconv(x, to = "ASCII//TRANSLIT"))

#Helpers de impressão
ver <- function(titulo, df, n = 10) {
  cat("\n===", titulo, "===\n")
  cat(sprintf("Linhas: %d  Colunas: %d\n", nrow(df), ncol(df)))
  print(head(df, n))
}

#Exercícios
# 1) Filtrar Jundiaí
ex1 <- dados |> filter(rm_acento_lower(nome_mun) == "jundiai")
ver("1) Jundiaí", ex1)

# 2) Selecionar colunas
ex2 <- dados |> select(nome_mun, sexo, populacao)
ver("2) nome_mun, sexo, populacao", ex2)

# 3) 2023 & Mulheres
ex3 <- dados |> filter(ano == 2023, tolower(sexo) %in% c("mulheres","feminino","f"))
ver("3) 2023 & Mulheres", ex3)

# 4) Nova coluna: milhares
ex4 <- dados |> mutate(milhares = populacao / 1000)
ver("4) + coluna 'milhares' (= populacao/1000)", ex4 |> select(nome_mun, sexo, populacao, milhares))

# 5) Top 10 populações
ex5 <- dados |> arrange(desc(populacao)) |> slice_head(n = 10)
ver("5) Top 10 populacoes", ex5)

# 6) Soma por município (2023)
ex6 <- dados |> filter(ano == 2023) |>
  group_by(nome_mun) |>
  summarise(pop_total = sum(populacao, na.rm = TRUE), .groups = "drop") |>
  arrange(desc(pop_total))
ver("6) Total por municipio (2023)", ex6, n = 15)

# 7) Média por faixa etária (2023)
ex7 <- dados |> filter(ano == 2023) |>
  group_by(idade) |>
  summarise(media_pop = mean(populacao, na.rm = TRUE), .groups = "drop") |>
  arrange(idade)
ver("7) Media por idade (2023)", ex7, n = 20)

# 8) Contagem por sexo
ex8 <- dados |> count(sexo, name = "qtde_registros") |> arrange(desc(qtde_registros))
ver("8) Contagem por sexo", ex8, n = nrow(ex8))

# 9) Populacao > 5000
ex9 <- dados |> filter(populacao > 5000)
ver(sprintf("9) Populacao > 5000 (total=%d)", nrow(ex9)), ex9)

# 10) Renomear nome_mun -> municipio
ex10 <- dados |> rename(municipio = nome_mun)
ver("10) Renomeado para 'municipio'", ex10)

# 11) cod_ibge + nome_mun + total em 2023
ex11 <- dados |> filter(ano == 2023) |>
  group_by(cod_ibge, nome_mun) |>
  summarise(pop_total_2023 = sum(populacao, na.rm = TRUE), .groups = "drop") |>
  arrange(desc(pop_total_2023))
ver("11) Totais por municipio (2023) com cod_ibge", ex11, n = 20)