
rm(list = ls())

prepare_ParsGBIF_workbook <- function(workbook = 'workbook_name',
                                      update = FALSE,
                                      url_collectorsDictionary = 'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/collectorDictionary/CollectorsDictionary.csv')
{
  {
    path_data <- paste0('./','data')
    if(!dir.exists(path_data)){dir.create(path_data)}
    
    path_wcvp <- paste0(path_data,'./','WCVP')
    if(!dir.exists(path_wcvp)){dir.create(path_wcvp)}
    
    path_maps <- paste0(path_data,'./','maps')
    if(!dir.exists(path_maps)){dir.create(path_maps)}
    # print('download borders of countries of the world to local disk')
    # world_countries <- raster::getData("countries", path=path_list_ParsGBIF$path_maps, download = TRUE)
    
    path_collectorsDictionary_repository <- paste0(path_data,'./','collectorsDictionary_repository')
    if(!dir.exists(path_collectorsDictionary_repository)){dir.create(path_collectorsDictionary_repository)}
    
    file_collectorsDictionary_repository <- paste0(path_collectorsDictionary_repository,'/','CollectorsDictionary.csv')
    
    if(! file.exists(file_collectorsDictionary_repository))
    {  
      print(paste0('download ',url_collectorsDictionary, ' to ', file_collectorsDictionary_repository ))
      write.csv(url_collectorsDictionary,
                file_collectorsDictionary_repository,
                row.names = FALSE,
                fileEncoding = "UTF-8",
                na = "")
    }
    
    
    path_workbook <- paste0('./',workbook)
    if(!dir.exists(path_workbook)){dir.create(path_workbook)}
    
    path_input <- paste0(path_workbook,'./','1_input_raw_data')
    if(!dir.exists(path_input)){dir.create(path_input)}
    
    file_input_occ <- paste0(path_input,'./','occurrence.txt')
    
    # output results of workflow steps
    path_output <- paste0(path_workbook,'./','2_output_results_workflow_steps')
    if(!dir.exists(path_output)){dir.create(path_output)}
    
    file_output_occ <- paste0(path_output,'./','output_1_occ.csv')
    
    file_output_extract_gbif_issue <- paste0(path_output,'./','output_2_extract_gbif_issue.csv')
    file_output_extract_gbif_issue_summary <- paste0(path_output,'./','output_2_extract_gbif_issue_summary.csv')
    
    file_output_checkName_wcvp <- paste0(path_output,'./','output_3_checkName_wcvp.csv')
    file_output_checkName_wcvp_summary <- paste0(path_output,'./','output_3_checkName_wcvp_summary.csv')
    
    file_output_collectorsDictionaryFromDataset <- paste0(path_output,'./','output_4_collectorsDictionaryFromDataset.csv')
    
    
    path_export <- paste0(path_workbook,'./','3_export')
    if(!dir.exists(path_export)){dir.create(path_export)}
  }
  
  return(list(workbook = workbook,
              path_workbook = path_workbook,
              path_input = path_input,
              path_output = path_output,
              path_export = path_export,
              path_wcvp = path_wcvp,
              path_maps = path_maps,
              
              file_collectorsDictionary_repository = file_collectorsDictionary_repository,
              
              file_input_occ = file_input_occ,
              
              file_output_occ = file_output_occ,
              
              file_output_extract_gbif_issue = file_output_extract_gbif_issue,
              file_output_extract_gbif_issue_summary = file_output_extract_gbif_issue_summary,
              
              file_output_checkName_wcvp = file_output_checkName_wcvp,
              file_output_checkName_wcvp_summary = file_output_checkName_wcvp_summary,
              
              file_output_collectorsDictionaryFromDataset = file_output_collectorsDictionaryFromDataset,
              
              update = update
  ))
  
  
}  

# isntall package, if changed since last installation
devtools::install_github("pablopains/ParsGBIF")

# load package
library(ParsGBIF)
library(raster)

# Prepare ParsGBIF workbook
  workbook <- prepare_ParsGBIF_workbook(workbook = 'projeto1',
                                        update = FALSE) # TRUE)
  workbook
  
  
  
  # Manually download, copy or unzip gbif portal query result per herbarium specimen  
  
  # Access an account registered on the GBIF portal 
  # Filter occurrences with the following parameters:
  # Basis of record: Preserved specimen, Occurrence status: present, Scientific name: Botanical family name 
  # Request to download information in DARWIN CORE ARCHIVE FORMAT
  # Download compressed file to default folder of raw GBIF file, indicate in workbook$path_input
  # Unzip downloaded file in workbook$path_input
  
  # default folder of raw GBIF file
  workbook$path_input
  
  list.files(workbook$path_input)
  
  
  # default path of raw GBIF file occurrence.txt file
  workbook$file_input_occ

  # or point your raw GBIF file occurrence.txt file
  # workbook$file_input_occ <- 'point your raw GBIF file occurrence.txt file'
  
  # Prepere GBIF raw occurrence data
  if(!file.exists(workbook$file_output_occ) | workbook$update == TRUE)
  {  
    occ <- prepere_gbif_occurrence_data(gbif_occurrece_file =  workbook$file_input_occ,
                                        columns = 'standard')
    
    head(occ)
    colnames(occ)
    
    print(paste0('write ', workbook$file_output_occ))
    
    write.csv(occ,
              workbook$file_output_occ,
              row.names = FALSE,
              fileEncoding = "UTF-8",
              na = "")
  }else
  {
    print(paste0('prepere_gbif_occurrence_data() - File already processed in: ',workbook$file_output_occ))
  }
  
  # Extract GBIF issue
  if(! file.exists(workbook$file_output_extract_gbif_issue) | workbook$update == TRUE)
  { 
    res_gbif_issue <- extract_gbif_issue(occ = occ)
    
    names(res_gbif_issue)
    head(res_gbif_issue$occ_gbif_issue)
    colnames(res_gbif_issue$occ_gbif_issue)
    head(res_gbif_issue$summary)
    
    print(paste0('extract_gbif_issue() - Files saved in: ',workbook$path_output))
    
    # issue occ
    print(paste0('write ', workbook$file_output_extract_gbif_issue))
    
    write.csv(res_gbif_issue$occ_gbif_issue,
              workbook$file_output_extract_gbif_issue,
              row.names = FALSE,
              fileEncoding = "UTF-8",
              na = "")
    
    # issue summary
    print(paste0('write ', workbook$file_output_extract_gbif_issue_summary))
    
    write.csv(res_gbif_issue$summary,
              workbook$file_output_extract_gbif_issue_summary,
              row.names = FALSE,
              fileEncoding = "UTF-8",
              na = "")
    
  }else
  {
    print(paste0('extract_gbif_issue() - File already processed in: ',workbook$file_output_extract_gbif_issue))
  }
  

  
  # 5) Use the World Checklist of Vascular Plants (WCVP) database to check accepted names and update synonyms
  
  res_checkName_wcvp <- batch_checkName_wcvp(occ = occ,
                                             wcvp_names =  wcvp_names,
                                             if_author_fails_try_without_combinations = TRUE,
                                             wcvp_selected_fields = 'standard')
  
  names(res_checkName_wcvp)
  
  head(res_checkName_wcvp$occ_checkName_wcvp)
  colnames(res_checkName_wcvp$occ_checkName_wcvp)
  
  head(res_checkName_wcvp$summary)
  
  if(! file.exists(workbook$file_output_checkName_wcvp) | workbook$update == TRUE )
  {  
    print(paste0('write ', workbook$file_output_checkName_wcvp))
    
    write.csv(res_checkName_wcvp$occ_checkName_wcvp,
              workbook$file_output_checkName_wcvp,
              row.names = FALSE,
              fileEncoding = "UTF-8",
              na = "")
  }
  
  
  
# 2.3) download borders of countries of the world to local disk
  world_countries <- raster::getData("countries", path=path_list_ParsGBIF$path_maps, download = TRUE)


# 1) get_wcvp()
help(get_wcvp)




help(batch_checkName_wcvp)

wcvp_names <- get_wcvp(read_only_to_memory = TRUE)$wcvp_names

occ <- prepere_gbif_occurrence_data(gbif_occurrece_file =  'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt',
                                    columns = 'standard')





library(rWCVPdata)
library(ParsGBIF)
library(dplyr)

devtools::install_github("matildabrown/rWCVPdata")
library(rWCVPdata)
library(dplyr)

# taxonomy data
wcvp_names <- rWCVPdata::wcvp_names %>%
  dplyr::mutate(TAXON_NAME_U = toupper(taxon_name),
                TAXON_AUTHORS_U = toupper(taxon_authors))


devtools::install_github("matildabrown/rWCVPdata")

