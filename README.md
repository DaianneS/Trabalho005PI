# Projeto Integrador 2 — Exercícios em R (Tarefa 005)

Este repositório contém a solução dos exercícios de manipulação e análise de dados em **R** aplicados a uma base demográfica por município, sexo e idade.
O foco é demonstrar, de forma reprodutível, operações fundamentais do ciclo de ciência de dados (importar, transformar, sumarizar e comunicar resultados no console).

## Conteúdo do repositório

```
.
├─ Tarefa005PIDaianneSoaresSilva.R     # script principal com a solução
├─ estimativa_pop_idade_sexo_esp.zip   # dados (CSV compactado)
└─ README.md                           # este documento
```

## Pré-requisitos

* **R 4.2** ou superior.
* Pacotes R utilizados pelo script (instalação automática caso ausentes):

  * `data.table`, `dplyr` (manipulação de dados)
  * `httr` (download/IO quando necessário)
  * `readr`, `tibble` (apoio, se usados no ambiente)

> Observação: o script foi escrito para **executar sem arquivos auxiliares**, lendo a base local (se existir) ou extraindo o **CSV** diretamente do `estimativa_pop_idade_sexo_esp.zip`.

## Como executar

### Opção A) R via linha de comando

No diretório do repositório:

```bash
Rscript Tarefa005PIDaianneSoaresSilva.R
```

### Opção B) RStudio

1. Abra o projeto/pasta no RStudio.
2. Abra `Tarefa005PIDaianneSoaresSilva.R`.
3. Clique em **Run** ou execute `source("Tarefa005PIDaianneSoaresSilva.R")`.

O script imprimirá no console **as prévias de cada etapa** (amostras de linhas), sem gravar arquivos no disco.

## Fluxo de dados

1. O script tenta ler `estimativa_pop_idade_sexo_esp.csv` **local** (se existir).
2. Caso não exista, ele usa `estimativa_pop_idade_sexo_esp.zip`, **extrai o CSV em pasta temporária** e lê com `data.table::fread`.
3. Em seguida, normaliza nomes de colunas (minúsculas, sublinhado) e tipos básicos (por exemplo, `ano`, `populacao`).

## Exercícios implementados

1. **Filtragem por município**: registros do município de **Jundiaí**.
2. **Seleção de colunas**: `nome_mun`, `sexo`, `populacao`.
3. **Filtragem composta**: **ano = 2023** e **sexo = Mulheres** (robusto a rótulos comuns).
4. **Nova variável**: `milhares = populacao / 1000`.
5. **Ordenação decrescente**: **Top 10** registros por `populacao`.
6. **Agrupamento e soma (2023)**: `pop_total` por `nome_mun`.
7. **Média por faixa etária (2023)**: `media_pop` por `idade`.
8. **Contagem por categoria**: total de registros por `sexo`.
9. **Filtro por valor**: `populacao > 5000`.
10. **Renomeação**: `nome_mun → municipio` e visualização inicial.
11. **Totais por município (2023)**: `cod_ibge`, `nome_mun` e `pop_total_2023`.

## Dicionário de dados (esperado)

* `cod_ibge` — código IBGE do município
* `nome_mun` — nome do município
* `ano` — ano de referência (ex.: 2023)
* `sexo` — categoria de sexo (ex.: “Mulheres”, “Homens”)
* `idade` — idade ou faixa etária
* `populacao` — estimativa populacional (numérico)

> Se a planilha original usar rótulos diferentes (p. ex., `municipio` em vez de `nome_mun`), o script padroniza por **aliases** comuns antes de executar os exercícios.

## Personalizações úteis

* **Município**: para filtrar outro município no Exercício 1, altere o valor comparado (a função de normalização trata acentos).
* **Sexo**: inclua outros rótulos equivalentes no vetor (`"mulheres","feminino","f"`).
* **Prévia no console**: ajuste o número de linhas exibidas nas funções de impressão (se presentes) ou use `head()`/`dplyr::slice_head()`.
