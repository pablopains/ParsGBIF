#' @title prepere_lastNameRecordedBy
#' @name prepere_lastNameRecordedBy
#'
#' @description Returns the last name of the primary collector.
#' If recordedBy is present in the collector's dictionary, it returns the checked name, if not, it returns the last name of the main collector, extracted from the recordedBy field.
#'   
#' @param occ GBIF occurrence file with selected columns
#' @param collectorDictionary_file Collector's dictionary file
#'
#' @details ....
#'   
#' @return 
#' Ctrl_nameRecordedBy_Standard,
#' Ctrl_recordedBy,
#' Ctrl_notes,
#' collectorDictionary,
#' Ctrl_update,
#' collectorName,
#' Ctrl_fullName,
#' Ctrl_fullNameII,
#' CVStarrVirtualHerbarium_PersonDetails
#'
#' @author Pablo Hendrigo Alves de Melo
#' @author Nadia Bystriakova
#' @author Alexandre Monro
#'
#' @seealso \code{\link[readr]{read_csv}}, \code{\link[unzip]{read.table}}
#'
#' @examples
#' collectorDictionary <- readr::read_csv('Collectors Dictionary.csv', 
#'                                        locale = readr::locale(encoding = "UTF-8"))
#'  
#' collectorsDictionaryFromDataset <- prepere_lastNameRecordedBy(occ=occ,
#'                                                               collectorDictionary=collectorDictionary)
#' 
#' @export
prepere_lastNameRecordedBy <- function(occ=NA, 
                                       collectorDictionary_file=NA)
{  

  require(stringr)
  if(!file.exists(collectorDictionary_file))
  {
    stop("CollectorDictionary file not found!")
  }  
  
  collectorDictionary <- readr::read_csv(collectorDictionary_file, 
                                         locale = readr::locale(encoding = "UTF-8"),
                                         show_col_types = FALSE) %>%
    dplyr::mutate(Ctrl_recordedBy = Ctrl_recordedBy %>% toupper()) %>%
    data.frame()   
  
  if(NROW(collectorDictionary)==0)
  {
    stop("CollectorDictionary is empty!")
  }  
  
  if(NROW(occ)==0)
  {
    stop("Occurrence is empty!")
  }  
  
   collectorDictionary <- collectorDictionary %>%
      dplyr::rename(Ctrl_nameRecordedBy_Standard_CNCFlora = Ctrl_nameRecordedBy_Standard)
   
   
   Ctrl_lastNameRecordedBy <- lapply(occ$Ctrl_recordedBy %>% 
                                        toupper() %>%
                                        unique(), 
                                     get_lastNameRecordedBy) %>% 
      do.call(rbind.data.frame, .)
   
   recordedBy_Standart <- data.frame(
      Ctrl_nameRecordedBy_Standard =  textclean::replace_non_ascii(toupper(Ctrl_lastNameRecordedBy[,1])),
      Ctrl_recordedBy = occ$Ctrl_recordedBy %>% toupper() %>% unique(),
      stringsAsFactors = FALSE) 

   recordedBy_Standart <- left_join(recordedBy_Standart,
                   collectorDictionary,
                   by = c('Ctrl_recordedBy')) %>%
      # dplyr::mutate(collectorDictionary='') %>% 
      dplyr::mutate(collectorDictionary=ifelse(!is.na(Ctrl_nameRecordedBy_Standard_CNCFlora),
                                       'Banco de Coletores OK',
                                       '')) %>%
      dplyr::mutate(Ctrl_nameRecordedBy_Standard = ifelse(collectorDictionary=='Banco de Coletores OK',
                                                          Ctrl_nameRecordedBy_Standard_CNCFlora,
                                                          Ctrl_nameRecordedBy_Standard)) %>% 
      dplyr::arrange(collectorDictionary, Ctrl_nameRecordedBy_Standard, Ctrl_recordedBy) %>%
   dplyr::mutate(Ctrl_notes = Ctrl_notes %>% as.character(),
                 Ctrl_update = Ctrl_update %>% as.character(),
                 Ctrl_nameRecordedBy_Standard = Ctrl_nameRecordedBy_Standard %>% as.character(),
                 Ctrl_recordedBy = Ctrl_recordedBy %>% as.character(),
                 collectorName = collectorName %>% as.character(),
                 Ctrl_fullName = Ctrl_fullName %>% as.character(),
                 Ctrl_fullNameII = Ctrl_fullNameII %>% as.character(),
                 CVStarrVirtualHerbarium_PersonDetails = CVStarrVirtualHerbarium_PersonDetails %>% as.character()) %>%
      # dplyr::select(Ctrl_notes,
      #               Ctrl_update,
      #               Ctrl_nameRecordedBy_Standard,
      #               Ctrl_recordedBy,
      #               collectorName,
      #               Ctrl_fullName,
      #               Ctrl_fullNameII,
      #               CVStarrVirtualHerbarium_PersonDetails)
   dplyr::select(Ctrl_nameRecordedBy_Standard,
                 Ctrl_recordedBy,
                 Ctrl_notes,
                 collectorDictionary,
                 Ctrl_update,
                 collectorName,
                 Ctrl_fullName,
                 Ctrl_fullNameII,
                 CVStarrVirtualHerbarium_PersonDetails)
   

   # # colnames(recordedBy_Standart)
   # xn <- nrow((recordedBy_Standart))
   # recordedBy_Standart <- recordedBy_Standart %>%
   #   dplyr::distinct_('Ctrl_recordedBy', .keep_all =TRUE)
   #   # dplyr::distinct('Ctrl_recordedBy', .keep_all =TRUE)
   # 
   # 
   # print( paste0(' Ctrl_recordedBy repetidos na base: ',xn-nrow(recordedBy_Standart)))
   
   return(recordedBy_Standart)
}
