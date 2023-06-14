
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

### Extracting GBIF issue to rank the quality of geographic coordinates

``` r
  library(ParsGBIF)

  occ_file <- 'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt'

  occ <- prepare_gbif_occurrence_data(gbif_occurrece_file = occ_file,
                                     columns = 'standard')
  
  
 occ_gbif_issue <- extract_gbif_issue(occ = occ)

 names(occ_gbif_issue)
#> [1] "occ_gbif_issue" "summary"

 head(occ_gbif_issue$summary)
#>                                              issue n_occ
#> 1                          INSTITUTION_MATCH_FUZZY  1919
#> 2                     GEODETIC_DATUM_ASSUMED_WGS84  1883
#> 3 OCCURRENCE_STATUS_INFERRED_FROM_INDIVIDUAL_COUNT  1336
#> 4               CONTINENT_DERIVED_FROM_COORDINATES  1038
#> 5                               COORDINATE_ROUNDED   978
#> 6                              TYPE_STATUS_INVALID   858

 colnames(occ_gbif_issue$occ_gbif_issue)
#>  [1] "COORDINATE_UNCERTAINTY_METERS_INVALID"            
#>  [2] "CONTINENT_COORDINATE_MISMATCH"                    
#>  [3] "CONTINENT_COUNTRY_MISMATCH"                       
#>  [4] "CONTINENT_DERIVED_FROM_COORDINATES"               
#>  [5] "CONTINENT_DERIVED_FROM_COUNTRY"                   
#>  [6] "COORDINATE_ACCURACY_INVALID"                      
#>  [7] "COORDINATE_PRECISION_INVALID"                     
#>  [8] "COORDINATE_PRECISION_UNCERTAINTY_MISMATCH"        
#>  [9] "COORDINATE_REPROJECTED"                           
#> [10] "ELEVATION_NON_NUMERIC"                            
#> [11] "ELEVATION_NOT_METRIC"                             
#> [12] "ELEVATION_UNLIKELY"                               
#> [13] "CONTINENT_INVALID"                                
#> [14] "COUNTRY_DERIVED_FROM_COORDINATES"                 
#> [15] "COUNTRY_INVALID"                                  
#> [16] "ELEVATION_MIN_MAX_SWAPPED"                        
#> [17] "COORDINATE_ROUNDED"                               
#> [18] "DEPTH_MIN_MAX_SWAPPED"                            
#> [19] "DEPTH_NON_NUMERIC"                                
#> [20] "DEPTH_NOT_METRIC"                                 
#> [21] "DEPTH_UNLIKELY"                                   
#> [22] "COUNTRY_MISMATCH"                                 
#> [23] "COORDINATE_REPROJECTION_FAILED"                   
#> [24] "COORDINATE_REPROJECTION_SUSPICIOUS"               
#> [25] "GEODETIC_DATUM_INVALID"                           
#> [26] "PRESUMED_NEGATED_LATITUDE"                        
#> [27] "PRESUMED_NEGATED_LONGITUDE"                       
#> [28] "PRESUMED_SWAPPED_COORDINATE"                      
#> [29] "GEODETIC_DATUM_ASSUMED_WGS84"                     
#> [30] "COORDINATE_INVALID"                               
#> [31] "COORDINATE_OUT_OF_RANGE"                          
#> [32] "COUNTRY_COORDINATE_MISMATCH"                      
#> [33] "ZERO_COORDINATE"                                  
#> [34] "AMBIGUOUS_COLLECTION"                             
#> [35] "AMBIGUOUS_INSTITUTION"                            
#> [36] "BASIS_OF_RECORD_INVALID"                          
#> [37] "COLLECTION_MATCH_FUZZY"                           
#> [38] "COLLECTION_MATCH_NONE"                            
#> [39] "DIFFERENT_OWNER_INSTITUTION"                      
#> [40] "FOOTPRINT_SRS_INVALID"                            
#> [41] "FOOTPRINT_WKT_INVALID"                            
#> [42] "FOOTPRINT_WKT_MISMATCH"                           
#> [43] "GEOREFERENCED_DATE_INVALID"                       
#> [44] "GEOREFERENCED_DATE_UNLIKELY"                      
#> [45] "IDENTIFIED_DATE_INVALID"                          
#> [46] "IDENTIFIED_DATE_UNLIKELY"                         
#> [47] "INDIVIDUAL_COUNT_CONFLICTS_WITH_OCCURRENCE_STATUS"
#> [48] "INDIVIDUAL_COUNT_INVALID"                         
#> [49] "INSTITUTION_COLLECTION_MISMATCH"                  
#> [50] "INSTITUTION_MATCH_FUZZY"                          
#> [51] "INSTITUTION_MATCH_NONE"                           
#> [52] "INTERPRETATION_ERROR"                             
#> [53] "MODIFIED_DATE_INVALID"                            
#> [54] "MODIFIED_DATE_UNLIKELY"                           
#> [55] "MULTIMEDIA_DATE_INVALID"                          
#> [56] "MULTIMEDIA_URI_INVALID"                           
#> [57] "OCCURRENCE_STATUS_INFERRED_FROM_BASIS_OF_RECORD"  
#> [58] "OCCURRENCE_STATUS_INFERRED_FROM_INDIVIDUAL_COUNT" 
#> [59] "OCCURRENCE_STATUS_UNPARSABLE"                     
#> [60] "POSSIBLY_ON_LOAN"                                 
#> [61] "RECORDED_DATE_INVALID"                            
#> [62] "RECORDED_DATE_MISMATCH"                           
#> [63] "RECORDED_DATE_UNLIKELY"                           
#> [64] "REFERENCES_URI_INVALID"                           
#> [65] "TAXON_MATCH_AGGREGATE"                            
#> [66] "TAXON_MATCH_FUZZY"                                
#> [67] "TAXON_MATCH_HIGHERRANK"                           
#> [68] "TAXON_MATCH_NONE"                                 
#> [69] "TYPE_STATUS_INVALID"
 
 head(occ_gbif_issue$occ_gbif_issue)
#>   COORDINATE_UNCERTAINTY_METERS_INVALID CONTINENT_COORDINATE_MISMATCH
#> 1                                 FALSE                         FALSE
#> 2                                 FALSE                         FALSE
#> 3                                 FALSE                         FALSE
#> 4                                 FALSE                         FALSE
#> 5                                 FALSE                         FALSE
#> 6                                 FALSE                         FALSE
#>   CONTINENT_COUNTRY_MISMATCH CONTINENT_DERIVED_FROM_COORDINATES
#> 1                      FALSE                              FALSE
#> 2                      FALSE                              FALSE
#> 3                      FALSE                              FALSE
#> 4                      FALSE                              FALSE
#> 5                      FALSE                              FALSE
#> 6                      FALSE                              FALSE
#>   CONTINENT_DERIVED_FROM_COUNTRY COORDINATE_ACCURACY_INVALID
#> 1                          FALSE                       FALSE
#> 2                          FALSE                       FALSE
#> 3                          FALSE                       FALSE
#> 4                          FALSE                       FALSE
#> 5                          FALSE                       FALSE
#> 6                          FALSE                       FALSE
#>   COORDINATE_PRECISION_INVALID COORDINATE_PRECISION_UNCERTAINTY_MISMATCH
#> 1                        FALSE                                     FALSE
#> 2                        FALSE                                     FALSE
#> 3                        FALSE                                     FALSE
#> 4                        FALSE                                     FALSE
#> 5                        FALSE                                     FALSE
#> 6                        FALSE                                     FALSE
#>   COORDINATE_REPROJECTED ELEVATION_NON_NUMERIC ELEVATION_NOT_METRIC
#> 1                  FALSE                 FALSE                FALSE
#> 2                  FALSE                 FALSE                FALSE
#> 3                  FALSE                 FALSE                FALSE
#> 4                  FALSE                 FALSE                FALSE
#> 5                  FALSE                 FALSE                FALSE
#> 6                  FALSE                 FALSE                FALSE
#>   ELEVATION_UNLIKELY CONTINENT_INVALID COUNTRY_DERIVED_FROM_COORDINATES
#> 1              FALSE             FALSE                            FALSE
#> 2              FALSE             FALSE                            FALSE
#> 3              FALSE             FALSE                            FALSE
#> 4              FALSE             FALSE                            FALSE
#> 5              FALSE             FALSE                            FALSE
#> 6              FALSE             FALSE                            FALSE
#>   COUNTRY_INVALID ELEVATION_MIN_MAX_SWAPPED COORDINATE_ROUNDED
#> 1           FALSE                     FALSE              FALSE
#> 2           FALSE                     FALSE               TRUE
#> 3           FALSE                     FALSE               TRUE
#> 4           FALSE                     FALSE               TRUE
#> 5           FALSE                     FALSE               TRUE
#> 6           FALSE                     FALSE              FALSE
#>   DEPTH_MIN_MAX_SWAPPED DEPTH_NON_NUMERIC DEPTH_NOT_METRIC DEPTH_UNLIKELY
#> 1                 FALSE             FALSE            FALSE          FALSE
#> 2                 FALSE             FALSE            FALSE          FALSE
#> 3                 FALSE             FALSE            FALSE          FALSE
#> 4                 FALSE             FALSE            FALSE          FALSE
#> 5                 FALSE             FALSE            FALSE          FALSE
#> 6                 FALSE             FALSE            FALSE          FALSE
#>   COUNTRY_MISMATCH COORDINATE_REPROJECTION_FAILED
#> 1            FALSE                          FALSE
#> 2            FALSE                          FALSE
#> 3            FALSE                          FALSE
#> 4            FALSE                          FALSE
#> 5            FALSE                          FALSE
#> 6            FALSE                          FALSE
#>   COORDINATE_REPROJECTION_SUSPICIOUS GEODETIC_DATUM_INVALID
#> 1                              FALSE                  FALSE
#> 2                              FALSE                  FALSE
#> 3                              FALSE                  FALSE
#> 4                              FALSE                  FALSE
#> 5                              FALSE                  FALSE
#> 6                              FALSE                  FALSE
#>   PRESUMED_NEGATED_LATITUDE PRESUMED_NEGATED_LONGITUDE
#> 1                     FALSE                      FALSE
#> 2                     FALSE                      FALSE
#> 3                     FALSE                      FALSE
#> 4                     FALSE                      FALSE
#> 5                     FALSE                      FALSE
#> 6                     FALSE                      FALSE
#>   PRESUMED_SWAPPED_COORDINATE GEODETIC_DATUM_ASSUMED_WGS84 COORDINATE_INVALID
#> 1                       FALSE                        FALSE              FALSE
#> 2                       FALSE                        FALSE              FALSE
#> 3                       FALSE                        FALSE              FALSE
#> 4                       FALSE                        FALSE              FALSE
#> 5                       FALSE                        FALSE              FALSE
#> 6                       FALSE                        FALSE              FALSE
#>   COORDINATE_OUT_OF_RANGE COUNTRY_COORDINATE_MISMATCH ZERO_COORDINATE
#> 1                   FALSE                       FALSE           FALSE
#> 2                   FALSE                       FALSE           FALSE
#> 3                   FALSE                       FALSE           FALSE
#> 4                   FALSE                       FALSE           FALSE
#> 5                   FALSE                       FALSE           FALSE
#> 6                   FALSE                       FALSE           FALSE
#>   AMBIGUOUS_COLLECTION AMBIGUOUS_INSTITUTION BASIS_OF_RECORD_INVALID
#> 1                FALSE                 FALSE                   FALSE
#> 2                FALSE                 FALSE                   FALSE
#> 3                FALSE                 FALSE                   FALSE
#> 4                FALSE                 FALSE                   FALSE
#> 5                FALSE                 FALSE                   FALSE
#> 6                FALSE                 FALSE                   FALSE
#>   COLLECTION_MATCH_FUZZY COLLECTION_MATCH_NONE DIFFERENT_OWNER_INSTITUTION
#> 1                   TRUE                 FALSE                       FALSE
#> 2                   TRUE                 FALSE                       FALSE
#> 3                   TRUE                 FALSE                       FALSE
#> 4                   TRUE                 FALSE                       FALSE
#> 5                   TRUE                 FALSE                       FALSE
#> 6                   TRUE                 FALSE                       FALSE
#>   FOOTPRINT_SRS_INVALID FOOTPRINT_WKT_INVALID FOOTPRINT_WKT_MISMATCH
#> 1                 FALSE                 FALSE                  FALSE
#> 2                 FALSE                 FALSE                  FALSE
#> 3                 FALSE                 FALSE                  FALSE
#> 4                 FALSE                 FALSE                  FALSE
#> 5                 FALSE                 FALSE                  FALSE
#> 6                 FALSE                 FALSE                  FALSE
#>   GEOREFERENCED_DATE_INVALID GEOREFERENCED_DATE_UNLIKELY
#> 1                      FALSE                       FALSE
#> 2                      FALSE                       FALSE
#> 3                      FALSE                       FALSE
#> 4                      FALSE                       FALSE
#> 5                      FALSE                       FALSE
#> 6                      FALSE                       FALSE
#>   IDENTIFIED_DATE_INVALID IDENTIFIED_DATE_UNLIKELY
#> 1                   FALSE                    FALSE
#> 2                   FALSE                    FALSE
#> 3                   FALSE                    FALSE
#> 4                   FALSE                    FALSE
#> 5                   FALSE                    FALSE
#> 6                   FALSE                    FALSE
#>   INDIVIDUAL_COUNT_CONFLICTS_WITH_OCCURRENCE_STATUS INDIVIDUAL_COUNT_INVALID
#> 1                                             FALSE                    FALSE
#> 2                                             FALSE                    FALSE
#> 3                                             FALSE                    FALSE
#> 4                                             FALSE                    FALSE
#> 5                                             FALSE                    FALSE
#> 6                                             FALSE                    FALSE
#>   INSTITUTION_COLLECTION_MISMATCH INSTITUTION_MATCH_FUZZY
#> 1                           FALSE                    TRUE
#> 2                           FALSE                    TRUE
#> 3                           FALSE                    TRUE
#> 4                           FALSE                    TRUE
#> 5                           FALSE                    TRUE
#> 6                           FALSE                    TRUE
#>   INSTITUTION_MATCH_NONE INTERPRETATION_ERROR MODIFIED_DATE_INVALID
#> 1                  FALSE                FALSE                 FALSE
#> 2                  FALSE                FALSE                 FALSE
#> 3                  FALSE                FALSE                 FALSE
#> 4                  FALSE                FALSE                 FALSE
#> 5                  FALSE                FALSE                 FALSE
#> 6                  FALSE                FALSE                 FALSE
#>   MODIFIED_DATE_UNLIKELY MULTIMEDIA_DATE_INVALID MULTIMEDIA_URI_INVALID
#> 1                  FALSE                   FALSE                  FALSE
#> 2                  FALSE                   FALSE                  FALSE
#> 3                  FALSE                   FALSE                  FALSE
#> 4                  FALSE                   FALSE                  FALSE
#> 5                  FALSE                   FALSE                  FALSE
#> 6                  FALSE                   FALSE                  FALSE
#>   OCCURRENCE_STATUS_INFERRED_FROM_BASIS_OF_RECORD
#> 1                                           FALSE
#> 2                                           FALSE
#> 3                                           FALSE
#> 4                                           FALSE
#> 5                                           FALSE
#> 6                                           FALSE
#>   OCCURRENCE_STATUS_INFERRED_FROM_INDIVIDUAL_COUNT OCCURRENCE_STATUS_UNPARSABLE
#> 1                                            FALSE                        FALSE
#> 2                                            FALSE                        FALSE
#> 3                                            FALSE                        FALSE
#> 4                                            FALSE                        FALSE
#> 5                                            FALSE                        FALSE
#> 6                                            FALSE                        FALSE
#>   POSSIBLY_ON_LOAN RECORDED_DATE_INVALID RECORDED_DATE_MISMATCH
#> 1            FALSE                 FALSE                  FALSE
#> 2            FALSE                 FALSE                  FALSE
#> 3            FALSE                 FALSE                  FALSE
#> 4            FALSE                 FALSE                  FALSE
#> 5            FALSE                 FALSE                  FALSE
#> 6            FALSE                 FALSE                  FALSE
#>   RECORDED_DATE_UNLIKELY REFERENCES_URI_INVALID TAXON_MATCH_AGGREGATE
#> 1                  FALSE                  FALSE                 FALSE
#> 2                  FALSE                  FALSE                 FALSE
#> 3                  FALSE                  FALSE                 FALSE
#> 4                  FALSE                  FALSE                 FALSE
#> 5                  FALSE                  FALSE                 FALSE
#> 6                  FALSE                  FALSE                 FALSE
#>   TAXON_MATCH_FUZZY TAXON_MATCH_HIGHERRANK TAXON_MATCH_NONE TYPE_STATUS_INVALID
#> 1             FALSE                  FALSE            FALSE               FALSE
#> 2             FALSE                  FALSE            FALSE               FALSE
#> 3             FALSE                  FALSE            FALSE               FALSE
#> 4             FALSE                  FALSE            FALSE               FALSE
#> 5             FALSE                  FALSE            FALSE               FALSE
#> 6             FALSE                  FALSE            FALSE               FALSE
```
