
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ParsGBIF

<!-- badges: start -->

[![R-CMD-check](https://github.com/p/ParsGBIF/pablopains/R-CMD-check/badge.svg)](https://github.com/pablopains/ParsGBIF/actions)
<!-- badges: end -->

ParsGBIF is a package for parsing species occurrence records based on
GBIF issues, WCVP names [World Checklist of Vascular
Plants](https://powo.science.kew.org//) and collector information

## Installation

You can install the development version of ParsGBIF from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
devtools::install_github("pablopains/ParsGBIF")
```

## Example

ParsGBIF makes it easy to get species occurrence records based on GBIF.

``` r
  library(ParsGBIF)

  help(prepare_gbif_occurrence_data)

  occ <- prepare_gbif_occurrence_data(gbif_occurrece_file =  'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt',
                                     columns = 'standard')

  colnames(occ)
 
  head(occ)
```
