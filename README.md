---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->

# ParsGBIF

<!-- badges: start -->
<!-- badges: start -->
[![R-CMD-check](https://github.com/p/ParsGBIF/pablopains/R-CMD-check/badge.svg)](https://github.com/pablopains/ParsGBIF/actions)
<!-- badges: end -->

<!-- badges: end -->

ParsGBIF is a package for parsing species occurrence records based on GBIF issues, WCVP names [World Checklist of Vascular Plants](https://powo.science.kew.org//) and collector information 

## Installation

You can install the development version of ParsGBIF from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
devtools::install_github("pablopains/ParsGBIF")
```

## Example

ParsGBIF makes it easy to get species occurrence records based on GBIF.

```{r example, eval=FALSE}
library(ParsGBIF)

path_root <- 'C:/ParsGBIF'

  help(get_wcvp)
  wcvp <- get_wcvp(url_source = 'http://sftp.kew.org/pub/data-repositories/WCVP/',
                                                         path_results = path_data,
                                                         update = FALSE,
                                                         load_distribution = FALSE)
  wcvp$wcvp_names
  wcvp$wcvp_distribution
```


