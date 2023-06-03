#' @details ParsGBIF - package creation - Only in development times
{
  rm(list = ls())
  
  library(devtools)
  setwd("C:\\ParsGBIF")
  # create("ParsGBIF", rstudio = FALSE)
  
  devtools::load_all()
  devtools::document()
  
  help(standardize_scientificName)
  help(get_wcvp)
  help(checkName_wcvp)
  help(prepere_lastNameRecordedBy)
  help(update_lastNameRecordedBy)
  help(extract_gbif_issue)
  help(select_digital_voucher_and_sample_identification)
  
}

path_root <- 'C:/ParsGBIF'
family <- 'Achatocarpaceae'
name_checked_collectorsDictionaryFromDataset_file <- 'ParsGBIF_3_collectorsDictionary_checked.csv'


#' @details Paths prepare
{
  
  path_data <- paste0(path_root,'/data')

  path_dataGBIF <- paste0(path_root,'/dataGBIF')
  if (!dir.exists(path_dataGBIF)){dir.create(path_dataGBIF)}
  
  path_dataGBIF_family <- paste0(path_dataGBIF,'/',family)
  if (!dir.exists(path_dataGBIF_family)){dir.create(path_dataGBIF_family)}
  
  
  gbif_file <- paste0(path_dataGBIF_family,'/occurrence.txt')
  gbif_sel_file <- paste0(path_dataGBIF_family,'/ParsGBIF_1_occurrence.csv')
  
  wcvp_result_file <- paste0(path_dataGBIF_family,'/ParsGBIF_2_checkName_wcvp.csv')
  
  
  collectorDictionary_file <- paste0(path_data,'/CollectorsDictionary.csv')
  collectorsDictionaryFromDataset_file <- paste0(path_dataGBIF_family,'/ParsGBIF_3_collectorsDictionary_raw.csv') 
  
  collectorsDictionaryFromDataset_checked_file <- paste0(path_dataGBIF_family,'/',name_checked_collectorsDictionaryFromDataset_file) 
  
  
  collectorsDictionary_summary_file <- paste0(path_dataGBIF_family,'/ParsGBIF_4_collectorsDictionary_summary.csv')

  collectorsDictionary_new_file <- paste0(path_dataGBIF_family,'/ParsGBIF_4_collectorsDictionary_new.csv')

  occurrence_collectorsDictionary_file <- paste0(path_dataGBIF_family,'/ParsGBIF_4_occurrence_collectorsDictionary.csv')
  
  
  enumOccurrenceIssue_file <- paste0(path_data,'/EnumOccurrenceIssue.csv')

  issueGBIFSummary_file <- paste0(path_dataGBIF_family,'/ParsGBIF_5_occurrence_issueGBIF_summary.csv')

  issueGBIFOccurrence_file <- paste0(path_dataGBIF_family,'/ParsGBIF_5_occurrence_issueGBIF.csv')


  result_file <- paste0(path_dataGBIF_family,'/ParsGBIF_6_result.csv')
  
}


#' @details Get WCVP
{
  help(get_wcvp)
  wcvp <- get_wcvp(url_source = 'http://sftp.kew.org/pub/data-repositories/WCVP/',
                                                         path_results = path_data,
                                                         update = FALSE,
                                                         load_distribution = FALSE)
  wcvp$wcvp_names
  wcvp$wcvp_distribution
}


#' @details Select GBIF fields
{
  col_sel <- c(
    # gbifID	
    # abstract	
    # accessRights	
    # accrualMethod	
    # accrualPeriodicity	
    # accrualPolicy	
    # alternative	
    # audience	
    # available	
    'bibliographicCitation',	
    # conformsTo	
    # contributor	
    # coverage	
    # created	
    # creator	
    # date	
    # dateAccepted	
    # dateCopyrighted	
    # dateSubmitted	
    # description	
    # educationLevel
    # extent
    # format
    # hasFormat
    # hasPart
    # hasVersion
    # identifier
    # instructionalMethod
    # isFormatOf
    # isPartOf
    # isReferencedBy
    # isReplacedBy
    # isRequiredBy
    # isVersionOf
    # issued
    'language',
    # license
    # mediator
    # medium
    # modified
    # provenance
    # publisher
    # references
    # relation
    # replaces
    # requires
    # rights
    # rightsHolder
    # source
    # spatial
    # subject
    # tableOfContents
    # temporal
    # title
    # type
    # valid
    # institutionID
    # collectionID
    # datasetID
    'institutionCode',
    'collectionCode',
    'datasetName',
    # ownerInstitutionCode
    'basisOfRecord',
    'informationWithheld', # especifica geo referenciamento
    'dataGeneralizations', # informações de campo
    # 'dynamicProperties', # DNA voucher
    'occurrenceID', # occ_search(occurrenceId='BRA:UNEMAT:HPAN:6089')
    'catalogNumber',
    'recordNumber',
    'recordedBy',
    # recordedByID
    # individualCount
    # organismQuantity
    # organismQuantityType
    # sex
    # lifeStage
    # reproductiveCondition
    # behavior
    # establishmentMeans
    # degreeOfEstablishment
    # pathway
    'georeferenceVerificationStatus',
    'occurrenceStatus',
    # preparations
    # disposition
    # associatedOccurrences
    # associatedReferences
    # associatedSequences
    # associatedTaxa
    # otherCatalogNumbers
    # occurrenceRemarks
    # organismID
    # organismName
    # organismScope
    # associatedOrganisms
    # previousIdentifications
    # organismRemarks
    # materialSampleID
    # eventID
    # parentEventID
    # fieldNumber
    'eventDate',
    # eventTime
    # startDayOfYear
    # endDayOfYear
    'year',
    'month',
    'day',
    # verbatimEventDate
    'habitat',
    # samplingProtocol
    # sampleSizeValue
    # sampleSizeUnit
    # samplingEffort
    'fieldNotes',
    'eventRemarks',
    'locationID',
    # higherGeographyID
    'higherGeography',
    # continent
    # waterBody
    'islandGroup',
    'island',
    'countryCode',
    'stateProvince',
    'county',
    'municipality',
    'locality',
    'verbatimLocality',
    # verbatimElevation
    # verticalDatum
    # verbatimDepth
    # minimumDistanceAboveSurfaceInMeters
    # maximumDistanceAboveSurfaceInMeters
    # locationAccordingTo
    'locationRemarks', # when countryCode is empty
    'decimalLatitude',
    'decimalLongitude',
    
    # 'coordinateUncertaintyInMeters', # only if georeferencedDate no empty
    
    # coordinatePrecision
    # pointRadiusSpatialFit
    'verbatimCoordinateSystem', # dicas sobre sistema geografico
    # verbatimSRS
    # footprintWKT
    # footprintSRS
    # footprintSpatialFit
    # georeferencedBy
    # 'georeferencedDate' # only if coordinateUncertaintyInMeters no empty
    # georeferenceProtocol
    # georeferenceSources
    # georeferenceRemarks
    # geologicalContextID
    # earliestEonOrLowestEonothem
    # latestEonOrHighestEonothem
    # earliestEraOrLowestErathem
    # latestEraOrHighestErathem
    # earliestPeriodOrLowestSystem
    # latestPeriodOrHighestSystem
    # earliestEpochOrLowestSeries
    # latestEpochOrHighestSeries
    # earliestAgeOrLowestStage
    # latestAgeOrHighestStage
    # lowestBiostratigraphicZone
    # highestBiostratigraphicZone
    # lithostratigraphicTerms
    # group
    # formation
    # member
    # bed
    # identificationID
    'verbatimIdentification',
    'identificationQualifier',
    'typeStatus',
    'identifiedBy',
    # identifiedByID
    'dateIdentified',
    # identificationReferences
    # identificationVerificationStatus
    # identificationRemarks
    # taxonID
    # scientificNameID
    # acceptedNameUsageID
    # parentNameUsageID
    # originalNameUsageID
    # nameAccordingToID
    # namePublishedInID
    # taxonConceptID
    'scientificName',
    # acceptedNameUsage
    # parentNameUsage
    # originalNameUsage
    # nameAccordingTo
    # namePublishedIn
    # namePublishedInYear
    # higherClassification
    # kingdom
    # phylum
    # class
    # order
    'family',
    # subfamily
    # genus
    # genericName
    # subgenus
    # infragenericEpithet
    # specificEpithet
    # infraspecificEpithet
    # cultivarEpithet
    'taxonRank',
    # verbatimTaxonRank
    # vernacularName
    'nomenclaturalCode',
    'taxonomicStatus',
    # nomenclaturalStatus
    # taxonRemarks
    # datasetKey
    # publishingCountry
    # lastInterpreted
    # elevation
    # elevationAccuracy
    # depth
    # depthAccuracy
    # distanceAboveSurface
    # distanceAboveSurfaceAccuracy
    'issue',
    'mediaType',
    'hasCoordinate',
    'hasGeospatialIssues',
    # taxonKey
    # acceptedTaxonKey
    # kingdomKey
    # phylumKey
    # classKey
    # orderKey
    # familyKey
    # genusKey
    # subgenusKey
    # speciesKey
    # species
    # acceptedScientificName
    'verbatimScientificName', 
    # typifiedName
    # protocol	
    # lastParsed
    # lastCrawled
    # repatriated
    # relativeOrganismQuantity
    'level0Gid',
    'level0Name',
    # level1Gid
    'level1Name',
    # level2Gid
    'level2Name',
    # level3Gid
    'level3Name'
    # iucnRedListCategory
  )
  
  
}


#' @details Load GBIF occurrence file and choose GBIF fields 
{

  if(!file.exists(gbif_sel_file))
  {
  occ <- readr::read_delim(file = gbif_file,
                                 delim = '\t',
                                 locale = readr::locale(encoding = "UTF-8"),
                                 show_col_types = FALSE)
  
  occ <- occ[ ,col_sel]

  colnames(occ) <- paste0('Ctrl_',colnames(occ))
  
  write.csv(occ, 
            gbif_sel_file, 
            row.names = FALSE, 
            fileEncoding = "UTF-8", 
            na = "")
  
  }else
  {  
  occ <- readr::read_delim(file = gbif_sel_file,
                           delim = ',',
                           locale = readr::locale(encoding = "UTF-8"),
                           show_col_types = FALSE)
  }
  
  NROW(occ)
}


#' @details Check names in WCVP
{
  if(!file.exists(wcvp_result_file))
  {
    index <- occ$Ctrl_taxonRank %>% toupper() %in%
      toupper(c('SPECIES',
                'VARIETY',
                'SUBSPECIES',
                'FORM'))
    
    wcvp_na <- data.frame(wcvp_plant_name_id  = NA,
                          # wcvp_ipni_id = NA,
                          wcvp_taxon_rank = NA,
                          wcvp_taxon_status = NA,
                          wcvp_family = NA,
                          # wcvp_genus_hybrid = NA,
                          # wcvp_genus = NA,
                          # wcvp_species_hybrid = NA,         
                          # wcvp_species = NA,
                          # wcvp_infraspecific_rank = NA,
                          # wcvp_infraspecies = NA,
                          # wcvp_parenthetical_author = NA,
                          # wcvp_primary_author = NA,
                          # wcvp_publication_author = NA,  
                          # wcvp_place_of_publication = NA,
                          # wcvp_volume_and_page = NA,        
                          # wcvp_first_published = NA,
                          # wcvp_nomenclatural_remarks = NA,
                          # wcvp_geographic_area = NA, 
                          # wcvp_lifeform_description = NA,   
                          # wcvp_climate_description = NA,
                          wcvp_taxon_name = NA,  
                          wcvp_taxon_authors = NA,
                          wcvp_accepted_plant_name_id = NA,
                          # wcvp_basionym_plant_name_id = NA,
                          # wcvp_replaced_synonym_author = NA,
                          # wcvp_homotypic_synonym = NA,
                          # wcvp_parent_plant_name_id = NA,   
                          # wcvp_powo_id = NA,
                          # wcvp_hybrid_formula = NA,
                          wcvp_reviewed = NA,
                          # # wcvp_TAXON_NAME_U = NA,
                          wcvp_searchedName = NA,
                          wcvp_taxon_status_of_searchedName = NA,
                          wcvp_plant_name_id_of_searchedName = NA,
                          wcvp_taxon_authors_of_searchedName = NA,
                          wcvp_verified_author = NA,
                          wcvp_verified_speciesName = NA,
                          wcvp_searchNotes = NA)
    
    colunas_wcvp_sel <- colnames(wcvp_na)
    
    occ_all <- cbind(occ, wcvp_na) %>%
      dplyr::mutate(wcvp_searchedName = Ctrl_scientificName) %>%
      dplyr::select(all_of(colunas_wcvp_sel))
    
    name_search_wcvp <- occ_all[index==TRUE,]$wcvp_searchedName %>% unique() %>% as.character()
    
    # https://powo.science.kew.org/about-wcvp#unplacednames
    
    x <- {}
    i <- 1
    tot_rec <- NROW(name_search_wcvp)
    
    for(i in 1:tot_rec)
    {
      sp_tmp <- name_search_wcvp[i]
      
      print( paste0( i, '-',tot_rec ,' ',  sp_tmp))
      
      x_tmp <- checkName_wcvp(searchedName = sp_tmp,
                                 wcvp_names = wcvp$wcvp_names,
                                 if_author_fails_try_without_combinations = TRUE)
      
      x <- rbind(x,
                 cbind(x_tmp[,
                             all_of(colunas_wcvp_sel)]))
      
      
      # n_reg <- NROW(occ_all[index==TRUE,])
      # print( str_c( i, ' - WCVP: ', name_search_wcvp[i], ' : ',n_reg, ' registros - ', ifelse(is.na(x_tmp$wcvp_taxon_name),'',x_tmp$wcvp_taxon_name),' ',x_tmp$wcvp_verified_author,' ',x_tmp$wcvp_verified_speciesName ,' : ', x_tmp$wcvp_searchNotes))
      
      
      index <- occ_all$wcvp_searchedName %in% sp_tmp #name_search_wcvp[i]  # wcvp_searchedName == Ctrl_scientificName
      occ_all[index==TRUE, all_of(colunas_wcvp_sel)] <- x_tmp[, all_of(colunas_wcvp_sel)]
      
      # # aqui
      # print( str_c( i, '-',tot_rec , ' - WCVP: ', sp_tmp,' -> ' ,ifelse(is.na(x_tmp$wcvp_taxon_name),'',x_tmp$wcvp_taxon_name),' ',x_tmp$wcvp_verified_author,' ',x_tmp$wcvp_verified_speciesName ,' : ', x_tmp$wcvp_searchNotes))
      
      # japrocessado[i] <- TRUE
    }
    
    wcvpSummary <<- x
    occ_wcpv <<- occ_all[,all_of(colunas_wcvp_sel)]
    
    write.csv(occ_wcpv, 
              wcvp_result_file, 
              row.names = FALSE, 
              fileEncoding = "UTF-8", 
              na = "")
  }else
  {
    occ_wcpv <- readr::read_delim(file = wcvp_result_file,
                             delim = ',',
                             locale = readr::locale(encoding = "UTF-8"),
                             show_col_types = FALSE)
  }
  
  NROW(occ_wcpv)
}


#' @details Prepare the collector dictionary from the data set
{
  
  help(prepere_lastNameRecordedBy)
  
  collectorsDictionaryFromDataset <- prepere_lastNameRecordedBy(occ=occ,
                                                                collectorDictionary_file=collectorDictionary_file)
  
  write.csv(collectorsDictionaryFromDataset, 
            collectorsDictionaryFromDataset_file, 
            row.names = FALSE, 
            fileEncoding = "UTF-8", 
            na = "")
  
}


#' @details Apply the collector dictionary from the data set
{
  
  help(update_lastNameRecordedBy)
  
  mainCollectorLastName <- update_lastNameRecordedBy(occ=occ,
                                                     collectorDictionary_checked_file=collectorsDictionaryFromDataset_checked_file,
                                                     collectorDictionary_file=collectorDictionary_file)
  
  collectorsDictionary_new <<- mainCollectorLastName[['MainCollectorLastNameDB_new']]
  
  occ <<- mainCollectorLastName[['occ']]
  
  collectorsDictionary_summary <<- mainCollectorLastName[['summary']]
  
 
  
  collectorsDictionary_summary_file <- paste0(path_dataGBIF_family,'/ParsGBIF_4_collectorsDictionary_summary.csv')
  
  collectorsDictionary_new_file <- paste0(path_dataGBIF_family,'/ParsGBIF_4_collectorsDictionary_new.csv')
  
  occurrence_collectorsDictionary_file <- paste0(path_dataGBIF_family,'/ParsGBIF_4_occurrence_collectorsDictionary.csv')
  
  write.csv(collectorsDictionary_summary, 
            collectorsDictionary_summary_file, 
            row.names = FALSE, 
            fileEncoding = "UTF-8", 
            na = "")
  

  write.csv(collectorsDictionary_new, 
            collectorsDictionary_new_file, 
            row.names = FALSE, 
            fileEncoding = "UTF-8", 
            na = "")

  
  write.csv(occ, 
            occurrence_collectorsDictionary_file, 
            row.names = FALSE, 
            fileEncoding = "UTF-8", 
            na = "")
  
   
}


#' @details Extract GBIF's issue
{
  
  enumOccurrenceIssue_file <- paste0(path_data,'/EnumOccurrenceIssue.csv')
  
  help(extract_gbif_issue)
  
  gbif_issue <- extract_gbif_issue(occ=occ,
                                   enumOccurrenceIssue_file = enumOccurrenceIssue_file) #"C:/ParsGBIF/data/EnumOccurrenceIssue.csv")

  
  write.csv(gbif_issue$issueGBIFSummary, 
            issueGBIFSummary_file, 
            row.names = FALSE, 
            fileEncoding = "UTF-8", 
            na = "")

  
  write.csv(gbif_issue$issueGBIFOccurrence, 
            issueGBIFOccurrence_file, 
            row.names = FALSE, 
            fileEncoding = "UTF-8", 
            na = "")
}


#' @details Selection of digital voucher and sample identification
{

  
  help(select_digital_voucher_and_sample_identification)
    
  occ <- select_digital_voucher_and_sample_identification(occurrence_collectorsDictionary_file = occurrence_collectorsDictionary_file,
                                                          issueGBIFOccurrence_file = issueGBIFOccurrence_file,
                                                          wcvp_occurence_file = wcvp_result_file,
                                                          enumOccurrenceIssue_file = enumOccurrenceIssue_file)
    
    
  write.csv(occ, 
            result_file, 
            fileEncoding = "UTF-8", 
            na = "", 
            row.names = FALSE)
  
  occ  %>%
    # dplyr::filter(Ctrl_matchStatusDuplicates != '') %>%
    dplyr::arrange(Ctrl_key_family_recordedBy_recordNumber) %>%
    View()
  
  
  
  
}
