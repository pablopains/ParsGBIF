
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ParsGBIF

<!-- badges: start -->

[![R-CMD-check](https://github.com/p/ParsGBIF/pablopains/R-CMD-check/badge.svg)](https://github.com/pablopains/ParsGBIF/actions)
[![Codecov test
coverage](https://codecov.io/gh/pablopains/ParsGBIF/branch/main/graph/badge.svg)](https://app.codecov.io/gh/pablopains/ParsGBIF?branch=main)
[![R-CMD-check](https://github.com/pablopains/ParsGBIF/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/pablopains/ParsGBIF/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

ParsGBIF package is designed to convert [Global Biodiversity Information
Facility - GBIF](https://www.gbif.org/) plant specimen occurrence data
to a more comprehensible format to be used for further analysis,
e.g. spatial. The package provides tools for verifying and standardizing
species scientific names, and for selecting the most informative species
records when duplicates are available. The Manual provides a brief
introduction to ParsGBIF, with more information available from Help
pages accessed via help(function_name).

## Installation

You can install the development version of ParsGBIF from
[GitHub](https://github.com/) with:

``` r
devtools::install_github("pablopains/ParsGBIF")
```

## Example

**ParsGBIF makes it easy to get species occurrence records based on
GBIF.**

### Obtaining occurrence data of the herbarium specimen in GBIF

1.  Access a registered account in [GBIF](gbif.org)

2.  Filter occurrences with the following parameters:

- Basis of record: *Preserved specimen*
- Occurrence status: *present*
- Scientific name: *Botanical family name* or **filter by other fields**

3.  Request to download information in **DARWIN CORE ARCHIVE FORMAT**

4.  Download compressed file and unzip downloaded file

5.  Use the **occurrence.txt** file as input to the
    prepare_gbif_occurrence_data(gbif_occurrece_file = ‘occurrence.txt’)
    function

### Preparing occurrence data to use in ParsGBIF package

``` r
  library(ParsGBIF)

  help(prepare_gbif_occurrence_data)

  occ_file <- 'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt'

  occ <- prepare_gbif_occurrence_data(gbif_occurrece_file = occ_file,
                                     columns = 'standard')

  colnames(occ)
#>  [1] "Ctrl_bibliographicCitation"          "Ctrl_language"                      
#>  [3] "Ctrl_institutionCode"                "Ctrl_collectionCode"                
#>  [5] "Ctrl_datasetName"                    "Ctrl_basisOfRecord"                 
#>  [7] "Ctrl_informationWithheld"            "Ctrl_dataGeneralizations"           
#>  [9] "Ctrl_occurrenceID"                   "Ctrl_catalogNumber"                 
#> [11] "Ctrl_recordNumber"                   "Ctrl_recordedBy"                    
#> [13] "Ctrl_georeferenceVerificationStatus" "Ctrl_occurrenceStatus"              
#> [15] "Ctrl_eventDate"                      "Ctrl_year"                          
#> [17] "Ctrl_month"                          "Ctrl_day"                           
#> [19] "Ctrl_habitat"                        "Ctrl_fieldNotes"                    
#> [21] "Ctrl_eventRemarks"                   "Ctrl_locationID"                    
#> [23] "Ctrl_higherGeography"                "Ctrl_islandGroup"                   
#> [25] "Ctrl_island"                         "Ctrl_countryCode"                   
#> [27] "Ctrl_stateProvince"                  "Ctrl_county"                        
#> [29] "Ctrl_municipality"                   "Ctrl_locality"                      
#> [31] "Ctrl_verbatimLocality"               "Ctrl_locationRemarks"               
#> [33] "Ctrl_decimalLatitude"                "Ctrl_decimalLongitude"              
#> [35] "Ctrl_verbatimCoordinateSystem"       "Ctrl_verbatimIdentification"        
#> [37] "Ctrl_identificationQualifier"        "Ctrl_typeStatus"                    
#> [39] "Ctrl_identifiedBy"                   "Ctrl_dateIdentified"                
#> [41] "Ctrl_scientificName"                 "Ctrl_family"                        
#> [43] "Ctrl_taxonRank"                      "Ctrl_nomenclaturalCode"             
#> [45] "Ctrl_taxonomicStatus"                "Ctrl_issue"                         
#> [47] "Ctrl_mediaType"                      "Ctrl_hasCoordinate"                 
#> [49] "Ctrl_hasGeospatialIssues"            "Ctrl_verbatimScientificName"        
#> [51] "Ctrl_level0Name"                     "Ctrl_level1Name"                    
#> [53] "Ctrl_level2Name"                     "Ctrl_level3Name"
 
  head(occ)
#> # A tibble: 6 × 54
#>   Ctrl_bibliographicCit…¹ Ctrl_language Ctrl_institutionCode Ctrl_collectionCode
#>   <chr>                   <chr>         <chr>                <chr>              
#> 1 <NA>                    es            Universidad de Anti… HUA                
#> 2 <NA>                    es            Universidad de Anti… HUA                
#> 3 <NA>                    es            Universidad de Anti… HUA                
#> 4 <NA>                    es            Universidad de Anti… HUA                
#> 5 <NA>                    es            Universidad de Anti… HUA                
#> 6 <NA>                    es            Universidad de Anti… HUA                
#> # ℹ abbreviated name: ¹​Ctrl_bibliographicCitation
#> # ℹ 50 more variables: Ctrl_datasetName <chr>, Ctrl_basisOfRecord <chr>,
#> #   Ctrl_informationWithheld <chr>, Ctrl_dataGeneralizations <chr>,
#> #   Ctrl_occurrenceID <chr>, Ctrl_catalogNumber <chr>, Ctrl_recordNumber <chr>,
#> #   Ctrl_recordedBy <chr>, Ctrl_georeferenceVerificationStatus <chr>,
#> #   Ctrl_occurrenceStatus <chr>, Ctrl_eventDate <dttm>, Ctrl_year <dbl>,
#> #   Ctrl_month <dbl>, Ctrl_day <dbl>, Ctrl_habitat <chr>, …
```
