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
  
  help(get_wcvp)

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
  
  
  help(checkName_wcvp)

  wcvp_names <- get_wcvp(read_only_to_memory = TRUE)$wcvp_names
  
 # Updated
 checkName_wcvp(searchedName = 'Hemistylus brasiliensis Wedd.',
                   wcvp_names = wcvp_names,
                   if_author_fails_try_without_combinations = TRUE)
 # Accepted
 checkName_wcvp(searchedName = 'Hemistylus boehmerioides Wedd. ex Warm.',
                   wcvp_names = wcvp_names,
                   if_author_fails_try_without_combinations = TRUE)
 
  # Unplaced - taxon_status = Unplaced
 checkName_wcvp(searchedName = 'Leucosyke australis Unruh',
                   wcvp_names = wcvp_names,
                   if_author_fails_try_without_combinations = TRUE)

 
 # Accepted among homonyms - When author is not informed. In this case, one of the homonyms, taxon_status is accepted
 checkName_wcvp(searchedName = 'Parietaria cretica',
                   wcvp_names = wcvp_names,
                   if_author_fails_try_without_combinations = TRUE)

 # When author is informed. 
 checkName_wcvp(searchedName = 'Parietaria cretica L.',
                   wcvp_names = wcvp_names,
                   if_author_fails_try_without_combinations = TRUE)

 # When author is informed. 
 checkName_wcvp(searchedName = 'Parietaria cretica Moris',
                   wcvp_names = wcvp_names,
                   if_author_fails_try_without_combinations = TRUE)

 # Homonyms - When author is not informed. In this case, none of the homonyms, taxon_status is Accepted
 checkName_wcvp(searchedName = 'Laportea peltata',
                   wcvp_names = wcvp_names,
                   if_author_fails_try_without_combinations = TRUE)
 
 # When author is informed. 
 checkName_wcvp(searchedName = 'Laportea peltata Gaudich. & Decne.',
                   wcvp_names = wcvp_names,
                   if_author_fails_try_without_combinations = TRUE)
 
 # When author is informed. 
 checkName_wcvp(searchedName = 'Laportea peltata (Blume) Gaudich.',
                   wcvp_names = wcvp_names,
                   if_author_fails_try_without_combinations = TRUE)

```


