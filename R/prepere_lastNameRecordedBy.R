#' @title prepere_lastNameRecordedBy
#' @name prepere_lastNameRecordedBy
#'
#' @description Returns the last name of the primary collector.
#' If recordedBy is present in the collector's dictionary, it returns the checked name, if not, it returns the last name of the main collector, extracted from the recordedBy field.
#'
#' @param occ GBIF occurrence table with selected columns as select_gbif_fields(columns = 'standard')
#' @param collectorDictionary_url Collector's dictionary URL curated by the ParsGBIF team 'https://docs.google.com/spreadsheets/d/15Ngrr4hbJnq_SsTycLJ6z15oCLPRyV2gFhQ3D1zXzuk/edit?usp=share_link'
#' @param collectorDictionary Collector's dictionary in data.frame format with the fields: Ctrl_nameRecordedBy_Standard, Ctrl_recordedBy, Ctrl_notes, collectorDictionary, Ctrl_update, collectorName, Ctrl_fullName, Ctrl_fullNameII, CVStarrVirtualHerbarium_PersonDetails
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
#' @seealso \code{\link[ParsGBIF]{select_gbif_fields}}, \code{\link[ParsGBIF]{update_lastNameRecordedBy}}
#'
#' @examples
#' collectorsDictionaryFromDataset <- prepere_lastNameRecordedBy(occ=occ,
#'                                                               collectorDictionary_url='https://docs.google.com/spreadsheets/d/15Ngrr4hbJnq_SsTycLJ6z15oCLPRyV2gFhQ3D1zXzuk/edit?usp=share_link')
#'
#'#' collectorsDictionaryFromDataset <- prepere_lastNameRecordedBy(occ=occ)
#'
#' @export
prepere_lastNameRecordedBy <- function(occ=NA,
                                       collectorDictionary_url='https://docs.google.com/spreadsheets/d/15Ngrr4hbJnq_SsTycLJ6z15oCLPRyV2gFhQ3D1zXzuk/edit?usp=share_link',
                                       collectorDictionary = NA)
{

  require(stringr)
  require(googlesheets4)

  if(!is.na(collectorDictionary))
  {
    if(is.na(collectorDictionary_url) | collectorDictionary_url == '')
    {
      stop("CollectorDictionary url not found!")
    }

    collectorDictionary <- googlesheets4::read_sheet(collectorDictionary_url)

    collectorDictionary <- collectorDictionary %>%
      dplyr::mutate(Ctrl_recordedBy = Ctrl_recordedBy %>% toupper()) %>%
      data.frame()

  }

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
