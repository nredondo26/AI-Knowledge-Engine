# R

Lenguaje interpretado, multiparadigma, tipado dinámico y fuerte. Creado por Ross Ihaka y Robert Gentleman (1993). Runtime: R GNU (CRAN). Filosofía: análisis estadístico, visualización, computación numérica, reproducibilidad.

## Sintaxis básica

```r
print("Hola, mundo")

nombre <- "Ana"
edad <- 30L            # L = integer
altura <- 1.75         # double
activo <- TRUE
nulo <- NULL
perdido <- NA          # missing value

# Vectores, listas, data.frames
vector <- c(1, 2, 3, 4, 5)
lista <- list(nombre = "Ana", edad = 30)
dataframe <- data.frame(nombre = c("Ana", "Luis"), edad = c(30, 25))

if (edad >= 18) {
  print("Mayor")
} else if (edad > 12) {
  print("Adolescente")
} else {
  print("Menor")
}

for (i in 1:5) print(i)
sapply(1:5, function(x) x^2)

sumar <- function(a, b) { return(a + b) }
```

## Tipado

Dinámico y fuerte. S3/S4/R6 sistemas de objetos. Coerción implícita limitada.

```r
typeof(1:5)            # "integer"
typeof(1.5)            # "double"
typeof("texto")        # "character"

# Coerción
c(TRUE, 1L, 2.5)      # double
c(TRUE, "texto")      # character

# NA handling
is.na(c(1, NA, 3))    # FALSE TRUE FALSE
na.omit(c(1, NA, 3))

# R6: POO moderna
library(R6)
Persona <- R6Class("Persona",
  public = list(
    nombre = NULL, edad = NULL,
    initialize = function(nombre, edad) {
      self$nombre <- nombre; self$edad <- edad
    },
    saludar = function() cat("Hola, soy", self$nombre, "\n")
  )
)
```

## tidyverse (análisis de datos)

```r
library(tidyverse)

datos <- tibble(
  nombre = c("Ana", "Luis", "Juan"),
  edad = c(30, 25, 35),
  ciudad = c("MX", "BO", "MX")
)

datos |>
  filter(edad > 25) |>
  group_by(ciudad) |>
  summarise(promedio = mean(edad), n = n()) |>
  arrange(desc(promedio))

# ggplot2
ggplot(datos, aes(x = nombre, y = edad, fill = ciudad)) +
  geom_col() + theme_minimal()

# purrr: funcional
list(1, 2, 3) |> map(~ .x * 2) |> keep(~ .x > 2) |> reduce(`+`)

# data.table: ultra rápido
library(data.table)
dt <- data.table(x = 1:1e6, y = runif(1e6))
dt[x > 500000, .(media = mean(y)), by = .(grupo = x %% 10)]
```

## Concurrencia

```r
library(parallel)

cl <- makeCluster(detectCores() - 1)
resultados <- parLapply(cl, 1:100, function(x) x^2)
stopCluster(cl)

# foreach con doParallel
library(foreach); library(doParallel)
registerDoParallel(cores = 4)
resultados <- foreach(i = 1:100, .combine = c) %dopar% { i^2 }

# Rcpp: C++ nativo
# library(Rcpp)
# cppFunction('int sumar(int a, int b) { return a + b; }')
```

## Ecosistema

- **CRAN** (~20k+ paquetes), **Bioconductor** (bioinformática)
- **RStudio / Posit** — IDE principal
- **Tidyverse**: dplyr, ggplot2, tidyr, readr, purrr, stringr
- **ML**: caret, tidymodels, xgboost, randomForest, keras, torch
- **Reporting**: R Markdown, Quarto, knitr, Shiny (apps interactivas)
- **Testing**: testthat, tinytest
- **Documentación**: roxygen2

## Herramientas

```bash
install.packages("tidyverse")
quarto render reporte.qmd --to pdf
shiny::runApp("app.R")
devtools::test()
devtools::document() && devtools::build()
```

## Relaciones

- [Ciencia de Datos](../../028-Data-Science/README.md)
- [Estadística](../../029-Statistics/README.md)
- [Visualización](../../030-Visualization/README.md)
```