#' @title prepere_collectorsDictionary
#' @name prepere_collectorsDictionary
#'
#' @description Returns the list with the last name of the main collector associated with the unique key recordedBy.
#'
#' @param occ GBIF occurrence table with selected columns as select_gbif_fields(columns = 'standard')
#' @param collectorDictionary_url Collector's dictionary URL curated by the ParsGBIF team 'https://docs.google.com/spreadsheets/d/15Ngrr4hbJnq_SsTycLJ6z15oCLPRyV2gFhQ3D1zXzuk/edit?usp=share_link'
#' The googlesheets4 package is requesting access to your Google account. Select a pre-authorised account or enter '0' to obtain a new token. Press Esc/Ctrl + C to cancel.
#' @param collectorDictionary_file Collector's dictionary file. Download a CollectorsDictionary.csv template from https://drive.google.com/file/d/1sYh1s39Ee3JgMQp2iyePOTdCB9gbaotW/view?usp=share_link
#'
#' @details If recordedBy is present in the collector's dictionary, it returns the checked name, if not, it returns the last name of the main collector, extracted from the recordedBy field.
#' If recordedBy is present in the collector's dictionary, returns the main collector's last name associated with the single recordedBy key,
#' otherwise, returns the main collector's last name, extracted from the recordedBy field.
#' It is recommended to curate the main collector's surname, automatically extracted from the recordedBy field.
#' The objective is to standardize the last name of the main collector.
#' That the primary botanical collector of a sample is always recognized by the same last name, standardized in capital letters and non-ascii characters replaced
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
#' @seealso \code{\link[ParsGBIF]{select_gbif_fields}}, \code{\link[ParsGBIF]{update_collectorsDictionary}},
#'          \code{\link[textclean]{replace_non_ascii}
#'
#' @examples
#' help(prepere_collectorsDictionary)
#'
#' occ <- prepere_gbif_occurrence_data(gbif_occurrece_file =  'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt',
#'                                     columns = 'standard')
#'
#' collectorsDictionaryFromDataset <- prepere_collectorsDictionary(occ=occ)
#'
#' colnames(collectorsDictionaryFromDataset)
#' head(collectorsDictionaryFromDataset)
#'
#' write.csv(collectorsDictionaryFromDataset,
#'           'collectorsDictionaryFromDataset.csv',
#'           row.names = FALSE,
#'           fileEncoding = "UTF-8",
#'           na = "")
#' @export
prepere_collectorsDictionary <- function(occ=NA,
                                       collectorDictionary_url='https://docs.google.com/spreadsheets/d/15Ngrr4hbJnq_SsTycLJ6z15oCLPRyV2gFhQ3D1zXzuk/edit?usp=share_link',
                                       collectorDictionary_file = NA)
{

  require(stringr)
  require(googlesheets4)
  require(dplyr)

  print('Loading collectorDictionary...')

  if(is.na(collectorDictionary_file))
  {
    if(is.na(collectorDictionary_url) | collectorDictionary_url == '')
    {
      stop("CollectorDictionary url not found!")
    }

    collectorDictionary <- googlesheets4::read_sheet(collectorDictionary_url)

  }else
  {
    collectorDictionary <- readr::read_csv(collectorDictionary_file,
                                           locale = readr::locale(encoding = "UTF-8"),
                                           show_col_types = FALSE)
  }

  if(NROW(collectorDictionary)==0)
  {
    stop("CollectorDictionary is empty!")
  }

  collectorDictionary <- collectorDictionary %>%
    dplyr::mutate(Ctrl_recordedBy = Ctrl_recordedBy %>% toupper()) %>%
    data.frame()

  if(NROW(occ)==0)
  {
    stop("Occurrence is empty!")
  }

   collectorDictionary <- collectorDictionary %>%
      dplyr::rename(Ctrl_nameRecordedBy_Standard_CNCFlora = Ctrl_nameRecordedBy_Standard)

   print("Extracting the main collector's surname....")

   Ctrl_lastNameRecordedBy <- lapply(occ$Ctrl_recordedBy %>%
                                        toupper() %>%
                                        unique(),
                                     get_lastNameRecordedBy) %>%
      do.call(rbind.data.frame, .)

   recordedBy_Standart <- data.frame(
      Ctrl_nameRecordedBy_Standard =  textclean::replace_non_ascii(toupper(Ctrl_lastNameRecordedBy[,1])),
      Ctrl_recordedBy = occ$Ctrl_recordedBy %>% toupper() %>% unique(),
      stringsAsFactors = FALSE)

   recordedBy_Standart <- dplyr::left_join(recordedBy_Standart,
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
