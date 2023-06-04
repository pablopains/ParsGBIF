#' @title select_digital_voucher_and_sample_identification
#' @name select_digital_voucher_and_sample_identification
#'
#' @description Extract gbif issue
#'
#' @param occurrence_collectorsDictionary_file result of the update_lastNameRecordedBy function
#' @param issueGBIFOccurrence_file result of the extract_gbif_issue function
#' @param wcvp_occurence_file result of the checkName_wcvp function
#' @param enumOccurrenceIssue_file An enumeration of validation rules for single occurrence records by GBIF file
#'
#' @details 
#' To group duplicates: 1) If the key to group duplicates is incomplete: Sample duplicates cannot be grouped due to missing collector information and/or collection number. Each record is considered a sample, with no duplicates. Select a voucher for each sample. 
#' Or, 2) If the key to group duplicates is complete: Group duplicates. Select a voucher, with the highest information score, among the duplicates in the sample.
#' How to calculate the information score?
#' moreInformativeRecord = sum of verbatim quality + quality of geospatial information. verbatim quality = sum of the number of flags with verbatim quality equal to TRUE. quality of geospatial information = If there is a geospatial issue, consider the one with the highest priority, with the highest score.
#' To select sample taxonomic identification: 1) If the key for grouping duplicates is complete: select the accepted TAXON_NAME, identified up to or below the specific level, most frequent among the duplicates in the sample. If tie between frequency of accepted TAXON_NAME, identified up to or below the specific level: select the first accepted TAXON_NAME, identified up to or below the specific level, in alphabetical order. If there is no identification, at or below the specific level, for the sample: Indicate as unidentified sample. 
#' Or, 2) If the key for grouping duplicates is incomplete: select TAXON_NAME, if accepted and identified up to or below the specified level. If there is no identification, at or below the specific level, for the sample: Indicate as unidentified sample.
#' @return 
#' matchStatusDuplicates - "matched", "unmatched: no recordedBy and no recordNumber", "unmatched: no recordNumber" or "unmatched: no recordedBy"
#' numberTaxonNamesSample -  count of the different accepted scientific names, identified up to or below the specific level, listed in the sample duplicates, or Zero, if there is no identification, equal to or below the specific level, for the sample.
#' sampleTaxonName - TAXON_name accepted and identified up to or below the specific level selected for the sample.
#' sampleIdentificationStatus - 'Identified', 'divergent identifications', or 'unidentified'
#' 
#' @author Pablo Hendrigo Alves de Melo
#' @author Nadia Bystriakova
#' @author Alexandre Monro
#'
#' @seealso \code{\link[utils]{unzip}}, \code{\link[unzip]{read.table}}
#'
#' @examples
#' occ <- select_digital_voucher_and_sample_identification(occurrence_collectorsDictionary_file = occurrence_collectorsDictionary_file,
#'                                                         issueGBIFOccurrence_file = issueGBIFOccurrence_file,
#'                                                         wcvp_occurence_file = wcvp_result_file,
#'                                                         enumOccurrenceIssue_file = enumOccurrenceIssue_file)
#' @export
select_digital_voucher_and_sample_identification <- function(occurrence_collectorsDictionary_file = NA,
                                                             issueGBIFOccurrence_file = NA,
                                                             wcvp_occurence_file = NA,
                                                             enumOccurrenceIssue_file = "C:/ParsGBIF/data/EnumOccurrenceIssue.csv")
{ 
  
  require(readr)
  # abrir
  {
    
    occ <- readr::read_csv(occurrence_collectorsDictionary_file,
                           locale = locale(encoding = "UTF-8"),
                           show_col_types = FALSE)
    
    
    occurrence_collectorsDictionary_file
    
    # file.csv <- paste0(path.result,'\\4_issueGBIFOccurrence - 2023-04-23.csv') 
    occ_issue <- readr::read_csv(issueGBIFOccurrence_file,
                                 locale = readr::locale(encoding = "UTF-8"),
                                 show_col_types = FALSE)
    
    
    # file.csv <- paste0(path.result,'\\occ_wcpv - 2023-04-23.csv') 
    occ_wcvo <- readr::read_csv(wcvp_occurence_file,
                                locale = readr::locale(encoding = "UTF-8"),
                                show_col_types = FALSE)
    
    occ <- cbind(occ_issue, occ, occ_wcvo)
    
    occ$Ctrl_taxonRank %>% unique()
    
    # "FAMILY"
    # "GENUS"
    # "SPECIES" 
    # "VARIETY" 
    # "FORM"    
    
    
    # occ$wcvp_taxon_rank %>% unique()
    occ$wcvp_taxon_rank <- ifelse(is.na(occ$wcvp_taxon_rank),'',occ$wcvp_taxon_rank)
    
    # occ$wcvp_taxon_status %>% unique()
    occ$wcvp_taxon_status <- ifelse(is.na(occ$wcvp_taxon_status),'',occ$wcvp_taxon_status)
    
    EnumOccurrenceIssue <- readr::read_csv(enumOccurrenceIssue_file, 
                                           locale = readr::locale(encoding = "UTF-8"), 
                                           show_col_types = FALSE)
    
    occ_issue <- colnames(occ)
    
    # geospatial_quality
    index_tmp1 <- EnumOccurrenceIssue$score == 1 & EnumOccurrenceIssue$type == 'geospatial' %>%
      ifelse(is.na(.), FALSE,.)
    index_tmp2 <- EnumOccurrenceIssue$score == 2 & EnumOccurrenceIssue$type == 'geospatial'%>%
      ifelse(is.na(.), FALSE,.)
    index_tmp3 <- EnumOccurrenceIssue$score == 3 & EnumOccurrenceIssue$type == 'geospatial'%>%
      ifelse(is.na(.), FALSE,.)
  }
  
  # verbatim_quality
  {
    occ <- occ %>%
      dplyr::mutate(temAnoColeta =  ifelse( is.na(Ctrl_year) | Ctrl_year == ""  | Ctrl_year == 0 | Ctrl_year <= 10,
                                            FALSE, TRUE) %>%
                      ifelse(is.na(.), FALSE,.),
                    
                    
                    temCodigoInstituicao = ifelse( is.na(Ctrl_institutionCode) | Ctrl_institutionCode=="",
                                                   FALSE, TRUE) %>%
                      ifelse(is.na(.), FALSE,.),
                    
                    
                    temNumeroCatalogo = ifelse( is.na(Ctrl_catalogNumber) | Ctrl_catalogNumber=="",
                                                FALSE, TRUE) %>%
                      ifelse(is.na(.), FALSE,.),
                    
                    
                    temColetor = ifelse( is.na(Ctrl_recordedBy) | Ctrl_recordedBy=="",
                                         FALSE, TRUE) %>%
                      ifelse(is.na(.), FALSE,.),
                    
                    
                    temNumeroColeta = ifelse( is.na(Ctrl_recordNumber) | Ctrl_recordNumber=="",
                                              FALSE, TRUE) %>%
                      ifelse(is.na(.), FALSE,.),
                    
                    # COUNTRY_MISMATCH
                    
                    temPais = ifelse( COUNTRY_INVALID==TRUE,
                                      FALSE, TRUE) %>%
                      ifelse(is.na(.), FALSE,.),
                    
                    
                    temUF = ifelse( is.na(Ctrl_stateProvince) | Ctrl_stateProvince=="",
                                    FALSE, TRUE) %>%
                      ifelse(is.na(.), FALSE,.),
                    
                    
                    temMunicipio = ifelse( is.na(Ctrl_municipality) | Ctrl_municipality=="",
                                           FALSE, TRUE) %>%
                      ifelse(is.na(.), FALSE,.),
                    
                    
                    temLocalidade = ifelse( is.na(Ctrl_locality) | Ctrl_locality=="",
                                            FALSE, TRUE) %>%
                      ifelse(is.na(.), FALSE,.),
                    
                    
                    temIdentificador = ifelse( is.na(Ctrl_identifiedBy) | Ctrl_identifiedBy=="",
                                               FALSE, TRUE) %>%
                      ifelse(is.na(.), FALSE,.),
                    
                    
                    temDataIdentificacao = ifelse( is.na(Ctrl_dateIdentified) | Ctrl_dateIdentified=="",
                                                   FALSE, TRUE) %>%
                      ifelse(is.na(.), FALSE,.),
                    
                    temCitacaoBibliografica = ifelse( is.na(Ctrl_bibliographicCitation) | Ctrl_bibliographicCitation=="",
                                                      FALSE, TRUE) %>%
                      ifelse(is.na(.), FALSE,.)
                    
      )
    
    # occ[,EnumOccurrenceIssue$Constant[index_tmp1 == TRUE]]
  }
  
  # for
  {
    
    occ <- occ %>% 
      dplyr::mutate(geospatial_quality = 0,
                    verbatim_quality = 0,
                    Ctrl_moreInformativeRecord = 0,
                    Ctrl_selectedMoreInformativeRecord = FALSE,
                    Ctrl_thereAreDuplicates = FALSE,
                    Ctrl_unmatched = FALSE,
                    Ctrl_unidentifiedSample = FALSE,
                    
                    # sample taxon name
                    Ctrl_sampleTaxonName = '',
                    # match status between duplicates
                    Ctrl_matchStatusDuplicates = '',
                    # sample identification status
                    Ctrl_sampleIdentificationStatus = '',
                    # number of taxon names for the sample
                    Ctrl_numberTaxonNamesSample = 0)
    
    occ <- occ %>%
      dplyr::mutate(geospatial_quality = ifelse(rowSums(occ[,EnumOccurrenceIssue$Constant[index_tmp3 == TRUE]])>0, -9,
                                                ifelse(rowSums(occ[,EnumOccurrenceIssue$Constant[index_tmp2 == TRUE]])>0, -3, 
                                                       ifelse(rowSums(occ[,EnumOccurrenceIssue$Constant[index_tmp1 == TRUE]])>0, -1, 0)))) 
    
    
    occ <- occ %>%
      dplyr::mutate(verbatim_quality = (  temColetor +
                                            temNumeroColeta +
                                            temAnoColeta +
                                            temCodigoInstituicao +
                                            temNumeroCatalogo +
                                            temLocalidade +
                                            temMunicipio +
                                            temUF + 
                                            temCitacaoBibliografica))
    
    occ <- occ %>%
      dplyr::mutate(Ctrl_moreInformativeRecord  = ( geospatial_quality + verbatim_quality))
    
    
    occ <- occ %>%
      dplyr::select(Ctrl_key_family_recordedBy_recordNumber,
                    wcvp_taxon_name,
                    wcvp_taxon_status,
                    wcvp_searchNotes,
                    # Ctrl_taxonRank,
                    geospatial_quality,
                    verbatim_quality,
                    Ctrl_moreInformativeRecord,
                    Ctrl_selectedMoreInformativeRecord,
                    Ctrl_thereAreDuplicates,
                    Ctrl_unmatched,
                    Ctrl_unidentifiedSample,
                    Ctrl_sampleTaxonName,
                    Ctrl_matchStatusDuplicates,
                    Ctrl_sampleIdentificationStatus,
                    Ctrl_numberTaxonNamesSample)
    
    index <- str_sub(occ$Ctrl_key_family_recordedBy_recordNumber, str_count(occ$Ctrl_key_family_recordedBy_recordNumber)-2, str_count(occ$Ctrl_key_family_recordedBy_recordNumber)) %in% '_NA'
    occ$Ctrl_key_family_recordedBy_recordNumber[index==TRUE] <- str_sub(occ$Ctrl_key_family_recordedBy_recordNumber[index==TRUE], 1, str_count(occ$Ctrl_key_family_recordedBy_recordNumber[index==TRUE])-2)
    
    
    recordedBy_unique <- occ$Ctrl_key_family_recordedBy_recordNumber %>% unique()
    
    # r <- recordedBy_unique[999]
    # r <- recordedBy_unique[2]
    # r <- recordedBy_unique[982]
    # r <- recordedBy_unique[1]
    # r <- 'ACHATOCARPACEAE_CAROL_'
    # r <- 'ACHATOCARPACEAE_CABRERA_'
    # r <- 'ACHATOCARPACEAE_CRISTOBAL_1254'
    # r <- 'ACHATOCARPACEAE__7862'
    r <- 'ACHATOCARPACEAE_ZARDINI_38377'
    r <- 'ACHATOCARPACEAE_AGUILAR-CANO_2271'
    r <- 'URTICACEAE_AHERN_619'
    r <- 'URTICACEAE_ACEVEDO-RODRIGUEZ_4423'
    r <- 'URTICACEAE_AMORIM_4433'
    
    r <-"URTICACEAE_CROAT_16297"
    r <- "URTICACEAE_BOZEMAN_45126"
    r <- "URTICACEAE_LONGBOTTOM_14525"
    
    r <- 'URTICACEAE_BANG_127'
    
    r <- 'URTICACEAE_BORDEN_1186'
    
    r <- 'URTICACEAE_SCHUNKE_7643'
    
    r <- 'URTICACEAE_WUNDERLIN_'
    
    r <- 'URTICACEAE_SEM-COLETOR_'
    # r 
    
    japrocessado <<- rep(FALSE,length(recordedBy_unique))
    
    tot <- NROW(recordedBy_unique)
    s <- 0
    
    for (r in recordedBy_unique)
    {
      s <- s+1
      
      if (s%%100==0){print(paste0(s, ' de ',tot))}
      
      if(japrocessado[s]==TRUE){next}
      
      # print(paste0(r, ' ',s, ' de ',tot))
      
      FAMILY__ <-  FAMILY__recordNumber <- FAMILY_recordedBy_ <- FALSE
      sp_name <- ''
      
      index_occ <- (occ$Ctrl_key_family_recordedBy_recordNumber %in% r) %>% ifelse(is.na(.), FALSE,.)
      
      num_records <- NROW(occ[index_occ==TRUE,])
      
      if (num_records == 0) 
      {
        print(r)
        print('table')
        break
      } 
      
      japrocessado[s] <- TRUE
      
      fam <-str_sub(r,1, str_locate(r, '_')[1]-1) %>% ifelse(is.na(.), "",.)
      
      if(str_sub(r, str_count(r), str_count(r)) == '_' | 
         grepl('__', r) |
         grepl('SEM-COLETOR',r))
      {
        
        FAMILY__ <- grepl('__', r) & str_locate(r, '__')[2] == str_count(r) %>% ifelse(is.na(.), FALSE,.)
        
        if(FAMILY__==FALSE)
        {
          
          # FAMILY_recordedBy_ <- (str_sub(r, str_count(r), str_count(r)) == '_' &
          #                          !str_sub(r, str_count(r)-1, str_count(r)-1) == '_') |
          #   grepl('SEM-COLETOR',r) %>% ifelse(is.na(.), FALSE,.)
          # 
          # if (FAMILY_recordedBy_==FALSE)
          # {
          #   FAMILY__recordNumber <- (grepl('__', r) &
          #                              str_locate(r, '__')[2] != str_count(r)) %>% ifelse(is.na(.), FALSE,.)
          # }
          
          
          FAMILY_recordedBy_ <- (grepl('__', r) &
                                   str_locate(r, '__')[2] != str_count(r)) |
            grepl('SEM-COLETOR',r) %>% ifelse(is.na(.), FALSE,.)
          
          if (FAMILY_recordedBy_==FALSE)
          {
            
            FAMILY__recordNumber <- (str_sub(r, str_count(r), str_count(r)) == '_' &
                                       !str_sub(r, str_count(r)-1, str_count(r)-1) == '_')  %>% ifelse(is.na(.), FALSE,.)
            
          }
          
        }
      }
      
      
      # unmatched
      if(FAMILY__ == TRUE | FAMILY__recordNumber == TRUE | FAMILY_recordedBy_== TRUE )
      {
        # incluir filtro espacial
        
        # nomes
        sp_name <- ifelse(occ[index_occ==TRUE, ]$wcvp_taxon_status == 'Accepted',
                          occ[index_occ==TRUE, ]$wcvp_taxon_name %>% as.character(),
                          '')
        
        occ[index_occ==TRUE, ] <- occ[index_occ==TRUE, ] %>%
          dplyr::mutate(Ctrl_selectedMoreInformativeRecord = TRUE,
                        Ctrl_unmatched = TRUE,
                        Ctrl_thereAreDuplicates = FALSE,
                        Ctrl_sampleTaxonName = sp_name,
                        Ctrl_unidentifiedSample = ifelse(sp_name %in% '', TRUE,FALSE),
                        Ctrl_matchStatusDuplicates = ifelse(FAMILY__==TRUE,
                                                            'unmatched: no recordedBy and no recordNumber', 
                                                            ifelse(FAMILY__recordNumber==TRUE,
                                                                   'unmatched: no recordNumber ',
                                                                   ifelse(FAMILY_recordedBy_==TRUE,
                                                                          'unmatched: no recordedBy', 'unmatched'))),
                        Ctrl_numberTaxonNamesSample = ifelse(sp_name %in% '',
                                                             0,
                                                             1),
                        Ctrl_sampleIdentificationStatus = ifelse(sp_name %in% '', 
                                                                 'unidentified',
                                                                 # paste0('unidentified: ', 
                                                                 #        ifelse(occ[index_occ==TRUE, ]$Ctrl_taxonRank %in%  c("SPECIES","VARIETY", "FORM", "SUBSPECIES"),
                                                                 #               occ[index_occ==TRUE, ]$wcvp_searchNotes,
                                                                 #               occ[index_occ==TRUE, ]$Ctrl_taxonRank)),
                                                                 'identified')
                        
          )
        
        # print('1 - Unmatched samples')
        next
      }
      
      occ[index_occ==TRUE, ] <- occ[index_occ==TRUE, ] %>%
        dplyr::mutate(Ctrl_matchStatusDuplicates = 'matched',
                      Ctrl_thereAreDuplicates = num_records > 1)
      
      # flaq para inidicar amostra não identificada
      
      if(!any(is.na(occ[index_occ==TRUE, ]$wcvp_taxon_name) == FALSE)) # any ???
      {
        
        # nomes
        sp_name <- rep('',num_records)
        
        occ[index_occ==TRUE, ] <- occ[index_occ==TRUE, ] %>%
          dplyr::mutate(Ctrl_matchStatusDuplicates = 'matched',
                        Ctrl_thereAreDuplicates = num_records > 1,
                        Ctrl_numberTaxonNamesSample = 0,
                        Ctrl_sampleTaxonName = sp_name,
                        # Ctrl_sampleIdentificationStatus = paste0('unidentified: ', 
                        #                                          ifelse(occ[index_occ==TRUE, ]$Ctrl_taxonRank %in%  c("SPECIES","VARIETY", "FORM", "SUBSPECIES"),
                        #                                                 occ[index_occ==TRUE, ]$wcvp_searchNotes,
                        #                                                 occ[index_occ==TRUE, ]$Ctrl_taxonRank)))
                        Ctrl_sampleIdentificationStatus = 'unidentified')
        
        # print('2 - Unidentified sample')
        
      } else
      {
        
        taxon_name_sample <- table(occ[index_occ==TRUE, ]$wcvp_taxon_name,
                                   # occ[index_occ==TRUE, ]$wcvp_searchNotes,
                                   occ[index_occ==TRUE, ]$wcvp_taxon_status,
                                   # occ[index_occ==TRUE, ]$Ctrl_taxonRank,
                                   exclude = NA) %>% 
          data.frame() %>%
          dplyr::filter(Freq > 0) %>%
          dplyr::arrange(desc(Freq),Var1)
        
        num_taxon_name <- NROW(taxon_name_sample)
        
        if(num_taxon_name==0)
        {
          
          print(occ[index_occ==TRUE, ]$wcvp_taxon_name) 
          
          print('0 - Error')
          
          break
        }
        
        
        if(num_taxon_name==1 & taxon_name_sample$Var2[1] %in% c('Accepted'))#,'Updated'))
        {
          sp_name <- taxon_name_sample$Var1[1] %>% as.character()
          
          occ[index_occ==TRUE, ] <- occ[index_occ==TRUE, ] %>%
            dplyr::mutate(Ctrl_matchStatusDuplicates = 'matched',
                          Ctrl_thereAreDuplicates = num_records > 1,
                          Ctrl_numberTaxonNamesSample = num_taxon_name,
                          Ctrl_sampleTaxonName = sp_name,
                          Ctrl_sampleIdentificationStatus = 'identified')
          
          # print('3 - Identified sample 100 %')
          
        }
        
        
        if(num_taxon_name>1)
        {
          ii=1
          for(ii in 1:NROW(taxon_name_sample))
          {
            
            if(taxon_name_sample$Var2[ii] %in% c('Accepted'))#,'Updated'))
            {
              sp_name <- taxon_name_sample$Var1[ii] %>% as.character()
              
              occ[index_occ==TRUE, ] <- occ[index_occ==TRUE, ] %>%
                dplyr::mutate(Ctrl_matchStatusDuplicates = 'matched',
                              Ctrl_thereAreDuplicates = num_records > 1,
                              Ctrl_numberTaxonNamesSample = num_taxon_name,
                              Ctrl_sampleTaxonName = sp_name,
                              Ctrl_sampleIdentificationStatus = 'divergent identifications')
              
              
              # print(paste0('4 - Identified sample ', 100/num_taxon_name,' %'))
              
              break  
            }
            
            
          }
          
        }
        
      }
      
      occ[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord <-
        (occ[index_occ==TRUE, ]$Ctrl_moreInformativeRecord ==
           max(occ[index_occ==TRUE, ]$Ctrl_moreInformativeRecord) )
      
      if (sum(occ[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord)>1)
      {
        
        index_end <- occ[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord == TRUE
        
        n_tmp <- NROW(occ[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==TRUE])
        
        if (n_tmp==1)
        {
          occ[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==FALSE] <- FALSE
        } else
        {
          occ[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==FALSE] <- FALSE
          occ[index_occ==TRUE, ]$Ctrl_selectedMoreInformativeRecord[index_end==TRUE][2:n_tmp] <- FALSE
        }   
        
        # print(paste0('6 - Selection of the more informative record ', 100/sum(index_end),' %'))
        
      }
      # else
      # {
      #   print(paste0('5 - Selection of the more informative record 100 %'))
      # }
    }
    
  }
  
  # salvar
  
  return(occ)
}
