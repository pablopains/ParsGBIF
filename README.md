---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->

# ParsGBIF

<!-- badges: start -->
[![R-CMD-check](https://github.com/p/ParsGBIF/pablopains/R-CMD-check/badge.svg)](https://github.com/pablopains/ParsGBIF/actions)
<!-- badges: end -->

ParsGBIF is a package for parsing species occurrence records based on GBIF issues, WCVP names [World Checklist of Vascular Plants](https://powo.science.kew.org//) and collector information 

## Installation

You can install the development version of ParsGBIF from [GitHub](https://github.com/) with:

``` r
devtools::install_github("pablopains/ParsGBIF")
```

## Example

ParsGBIF makes it easy to get species occurrence records based on GBIF.

```{r example, eval=FALSE}

  # load package
  library(ParsGBIF)
  
  # function help
  help(get_wcvp)
  
  # get_wcvp()

  # 1.1) download wcvp database to local disk
  path_root <- 'C:/ParsGBIF'
  wcvp <- get_wcvp(url_source = 'http://sftp.kew.org/pub/data-repositories/WCVP/',
                                                         read_only_to_memory = FALSE
                                                         path_results = path_data,
                                                         update = FALSE,
                                                         load_distribution = TRUE)
  names(wcvp)    
  
  head(wcvp$wcvp_names)
  colnames(wcvp$wcvp_names)

  head(wcvp$wcvp_distribution)
  colnames(wcvp$wcvp_distribution)
  

  # 1.2) or, just load it into memory
  wcvp_names <- get_wcvp(read_only_to_memory = TRUE)$wcvp_names
  
  colnames(wcvp_names)
  head(wcvp_names)
  

```


