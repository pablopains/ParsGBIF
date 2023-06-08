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

  rm(list = ls())
  
  # load package
  library(ParsGBIF)
  
  # 1) get_wcvp()
  help(get_wcvp)

  # 1.1) download wcvp database to local disk
  path_data <- tempdir() # you can change this folder
  
  wcvp <- get_wcvp(url_source = 'http://sftp.kew.org/pub/data-repositories/WCVP/',
                   read_only_to_memory = FALSE,
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


  
  # 2) checkName_wcvp()
  
  help(checkName_wcvp)

  wcvp_names <- get_wcvp(read_only_to_memory = TRUE)$wcvp_names
  
 # 2.1) Updated
 checkName_wcvp(searchedName = 'Hemistylus brasiliensis Wedd.',
                   wcvp_names = wcvp_names,
                   if_author_fails_try_without_combinations = TRUE)
 # 2.2) Accepted
 checkName_wcvp(searchedName = 'Hemistylus boehmerioides Wedd. ex Warm.',
                   wcvp_names = wcvp_names,
                   if_author_fails_try_without_combinations = TRUE)
 
 # 2.3) Unplaced - taxon_status = Unplaced
 checkName_wcvp(searchedName = 'Leucosyke australis Unruh',
                   wcvp_names = wcvp_names,
                   if_author_fails_try_without_combinations = TRUE)

 
 # 2.4) Accepted among homonyms - When author is not informed. In this case, one of the homonyms, taxon_status is accepted
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

 # 2.5) Homonyms - When author is not informed. In this case, none of the homonyms, taxon_status is Accepted
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
                   


 # 3) standardize_scientificName()
 
 help(standardize_scientificName)
 
 standardize_scientificName('Leucanthemum ×superbum (Bergmans ex J.W.Ingram) D.H.Kent')
 
 standardize_scientificName('Alomia angustata (Gardner) Benth. ex Baker')
 
 standardize_scientificName('Centaurea ×aemiliae Font Quer')


 
 # 4) select_gbif_fields()
 
 help(select_gbif_fields)

 col_sel <- select_gbif_fields(columns = 'all')
 
 col_sel
 
 col_sel <- select_gbif_fields(columns = 'standard')
 
 col_sel
 
 # 5) prepere_gbif_occurrence_data()

 help(prepere_gbif_occurrence_data)

  occ <- prepere_gbif_occurrence_data(gbif_occurrece_file =  'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt',
                                     columns = 'standard')

 colnames(occ)
 
 head(occ)
 
 
 # 6) extract_gbif_issue()  
 help(extract_gbif_issue)
 
 occ <- prepere_gbif_occurrence_data(gbif_occurrece_file =  'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt',
                                     columns = 'standard')
 
 data(EnumOccurrenceIssue)
 head(EnumOccurrenceIssue)
 colnames(EnumOccurrenceIssue)
 
 occ_gbif_issue <- extract_gbif_issue(occ = occ,
                                enumOccurrenceIssue = NA)

 names(occ_gbif_issue)
 
 head(occ_gbif_issue$issueGBIFSummary)
 
 colnames(occ_gbif_issue$issueGBIFOccurrence)
 head(occ_gbif_issue$issueGBIFOccurrence)
 colnames(occ_gbif_issue$issueGBIFOccurrence)


 # 7) get_lastNameRecordedBy()  
 
 help(get_lastNameRecordedBy)
 
 get_lastNameRecordedBy('Melo, P.H.A & Monro, A.')

 get_lastNameRecordedBy('Monro, A. & Melo, P.H.A')

 get_lastNameRecordedBy('Monro, A.; Melo, P.H.A')

 get_lastNameRecordedBy('Monro, A; Melo, P.H.A;')

 get_lastNameRecordedBy('Monro,A Melo, P.H.A')

 get_lastNameRecordedBy('Monro A. - Melo, P.H.A')
 
 get_lastNameRecordedBy('Monro A Melo, P.H.A')

 
 # 8) prepere_collectorsDictionary()  
 help(prepere_collectorsDictionary)

  occ <- prepere_gbif_occurrence_data(gbif_occurrece_file =  'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt',
                                     columns = 'standard')
 
 collectorsDictionaryFromDataset <- prepere_collectorsDictionary(occ=occ)

 colnames(collectorsDictionaryFromDataset)
 head(collectorsDictionaryFromDataset)

  write.csv(collectorsDictionaryFromDataset,
            'collectorsDictionaryFromDataset.csv',
            row.names = FALSE,
            fileEncoding = "UTF-8",
            na = "")
            
            
 
 # 9) update_collectorsDictionary()
 
 help(update_collectorsDictionary)

  occ <- prepere_gbif_occurrence_data(gbif_occurrece_file =  'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt',
                                     columns = 'standard')

  occ_mainCollectorLastName <- update_collectorsDictionary(occ=occ,
                                                         collectorDictionary_checked = collectorsDictionaryFromDataset)


  names(occ_mainCollectorLastName)
  
  head(occ_mainCollectorLastName[['occ']])

  head(occ_mainCollectorLastName[['summary']])

  head(occ_mainCollectorLastName[['MainCollectorLastNameDB_new']])


 # 10) batch_checkName_wcvp()
 
  help(batch_checkName_wcvp)
 
  wcvp_names <- get_wcvp(read_only_to_memory = TRUE)$wcvp_names

  occ <- prepere_gbif_occurrence_data(gbif_occurrece_file =  'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt',
                                     columns = 'standard')
 
 res_batch_checkName_wcvp <- batch_checkName_wcvp(occ = occ,
                                 wcvp_names =  wcvp_names,
                                 if_author_fails_try_without_combinations = TRUE,
                                 wcvp_selected_fields = 'standard')
 
  names(res_batch_checkName_wcvp)
  
  head(res_batch_checkName_wcvp$wcvpSummary)

  head(res_batch_checkName_wcvp$wcvpOccurrence)

 # 11) select_digital_voucher_and_sample_identification()
 
 help(select_digital_voucher_and_sample_identification)
 

  occ <- select_digital_voucher_and_sample_identification(occurrence_collectorsDictionary_file = occurrence_collectorsDictionary_file,
                                                          issueGBIFOccurrence_file = issueGBIFOccurrence_file,
                                                          wcvp_occurence_file = wcvp_result_file,
                                                          enumOccurrenceIssue_file = enumOccurrenceIssue_file)

 # 12) export_results

```


