#' @title update_lastNameRecordedBy
#' @name update_lastNameRecordedBy
#'
#' @description Include recordedByStandardized field with verified main collector's last name.
#' Include recordNumber_Standard field with only numbers from recordNumber.
#' Create a key to group duplicates in the key_family_recordedBy_recordNumber field, composed of the fields: family + recordedByStandardized + recordNumber_Standard.
#'
#' @param occ GBIF occurrence table with selected columns as select_gbif_fields(columns = 'standard')
#' @param collectorDictionary_checked_file Verified collector's dictionary file
#' @param collectorDictionary_checked Verified collector's dictionary data.frame
#' @param collectorDictionary_url Collector's dictionary URL curated by the ParsGBIF team 'https://docs.google.com/spreadsheets/d/15Ngrr4hbJnq_SsTycLJ6z15oCLPRyV2gFhQ3D1zXzuk/edit?usp=share_link'
#' @param collectorDictionary Collector's dictionary in data.frame format with the fields: Ctrl_nameRecordedBy_Standard, Ctrl_recordedBy, Ctrl_notes, collectorDictionary, Ctrl_update, collectorName, Ctrl_fullName, Ctrl_fullNameII, CVStarrVirtualHerbarium_PersonDetails.
#' if you prefer, download a CollectorsDictionary.csv template from https://drive.google.com/file/d/1sYh1s39Ee3JgMQp2iyePOTdCB9gbaotW/view?usp=share_link
#'
#' @details ....
#'
#' @return
#' collectorsDictionary_new,
#' recordNumber_Standard,
#' collectorsDictionary_summary
#'
#' @author Pablo Hendrigo Alves de Melo
#' @author Nadia Bystriakova
#' @author Alexandre Monro
#'
#' @encoding UTF-8
#'
#' @seealso \code{\link[readr]{read_csv}}, \code{\link[unzip]{read.table}}
#'
#' @examples
#'
#' collectorsDictionaryFromDataset <- prepere_lastNameRecordedBy(occ=occ,
#'                                                               collectorDictionary_checked_file='collectorDictionary_checked.csv')
#'
#' @export
update_lastNameRecordedBy <- function(occ=NA,
                                      collectorDictionary_checked_file = NA,
                                      collectorDictionary_checked = NA,
                                      collectorDictionary_url = 'https://docs.google.com/spreadsheets/d/15Ngrr4hbJnq_SsTycLJ6z15oCLPRyV2gFhQ3D1zXzuk/edit?usp=share_link',
                                      collectorDictionary = NA)
{

  require(googlesheets4)

  print('Loading collectorDictionary...')

  if(is.na(collectorDictionary))
  {
    if(is.na(collectorDictionary_url) | collectorDictionary_url == '')
    {
      stop("CollectorDictionary url not found!")
    }

    collectorDictionary <- googlesheets4::read_sheet(collectorDictionary_url)
  }

  if(NROW(collectorDictionary)==0)
  {
    stop("Collector dictionary is empty!")
  }

  collectorDictionary <- collectorDictionary %>%
    dplyr::mutate(Ctrl_recordedBy = Ctrl_recordedBy %>% toupper()) %>%
    data.frame()

  if(is.na(collectorDictionary_checked))
  {
    if(!file.exists(collectorDictionary_checked_file))
    {
      stop("Collector dictionary checked file not found!")
    }

    collectorDictionary_checked <- readr::read_csv(collectorDictionary_file,
                                           locale = readr::locale(encoding = "UTF-8"),
                                           show_col_types = FALSE)
  }

  collectorDictionary_checked <- collectorDictionary_checked %>%
    dplyr::mutate(Ctrl_recordedBy = Ctrl_recordedBy %>% toupper()) %>%
    data.frame()


  if(NROW(collectorDictionary_checked)==0)
  {
    stop("Collector dictionary checked is empty!")
  }

  if(NROW(occ)==0)
  {
    stop("Occurrence is empty!")
  }


   colunas <- colnames(collectorDictionary)

   collectorDictionary <- collectorDictionary %>%
      dplyr::rename(Ctrl_nameRecordedBy_Standard_CNCFlora = Ctrl_nameRecordedBy_Standard) %>%
      dplyr::select(Ctrl_recordedBy, Ctrl_nameRecordedBy_Standard_CNCFlora)

   collectorDictionary_checked$Ctrl_recordedBy <- collectorDictionary_checked$Ctrl_recordedBy %>%
      toupper() %>% as.character()

   collectorDictionary$Ctrl_recordedBy <- collectorDictionary$Ctrl_recordedBy %>%
      toupper() %>% as.character()

   collectorDictionary_checked_new <- anti_join(collectorDictionary_checked,
                                       collectorDictionary,
                                       by = c('Ctrl_recordedBy')) %>%
      dplyr::select(colunas)

   ####

   occ <- occ %>%
      dplyr::mutate(Ctrl_nameRecordedBy_Standard='')

   recordedBy_unique <- occ$Ctrl_recordedBy %>% unique() %>%  as.factor()
   recordedBy_unique <- recordedBy_unique %>% toupper()
   # NROW(recordedBy_unique)

   print("let's go...")
   print(NROW(recordedBy_unique))

   # atualizando tabela de occorencias

   rt <- NROW(recordedBy_unique)
   ri <- 0

   r=recordedBy_unique[1]
   for (r in recordedBy_unique)
   {
      ri <- ri + 1

      if (is.na(r)) {next}
      index_occ <- (occ$Ctrl_recordedBy %>% toupper() %in% r) %>% ifelse(is.na(.), FALSE,.)
      num_records <- NROW(occ[index_occ==TRUE,])
      index_ajusted <- (collectorDictionary_checked$Ctrl_recordedBy == r) %>% ifelse(is.na(.), FALSE,.)

      # sum(index_ajusted)
      # any(index_ajusted)

      # group_by_(campo) %>% summarise(frecuencia = n() ))
      # collectorDictionary_checked[index_ajusted==TRUE,] %>% dplyr::select(Ctrl_recordedBy)

      print(paste0(ri, ' de ', rt, ' - ', r,' : ',num_records, ' registros' ))

      if (NROW(collectorDictionary_checked[index_ajusted==TRUE,]) == 0)
      {
         # occ[index_occ==TRUE, c('Ctrl_nameRecordedBy_Standard')] =
         #    data.frame(Ctrl_nameRecordedBy_Standard  = 'undefined collector')
         print(r)
         print('in ajusted')
         next
      }

      if (num_records == 0)
      {
         print(r)
         print('table')
         break
      }

      collectorDictionary_checked_tmp <- collectorDictionary_checked %>%
         dplyr::filter(index_ajusted) %>%
         dplyr::select(Ctrl_nameRecordedBy_Standard)

      # 09-09-2022
      collectorDictionary_checked_tmp <- collectorDictionary_checked_tmp[1,]

      # 18-10-21
      #pode-se ajustar aqui as duplicações

      occ[index_occ==TRUE, c('Ctrl_nameRecordedBy_Standard')] =
         data.frame(Ctrl_nameRecordedBy_Standard  = collectorDictionary_checked_tmp)

      # # 08-02-2022 - desliguei essa conferencia desnecessária e que exige grande processamento
      # index_ck <- occ$Ctrl_nameRecordedBy_Standard %in% collectorDictionary_checked_tmp &
      #    index_occ
      #
      # num_records_ck <- NROW(occ[index_ck==TRUE,])
      #
      # # print(num_records)
      # if ((num_records-num_records_ck)>0){print(num_records-num_records_ck)}

   }

   print('...finished!')

   # teste antigo removido

   occ$Ctrl_recordNumber_Standard <- str_replace_all(occ$Ctrl_recordNumber, "[^0-9]", "")


   occ$Ctrl_recordNumber_Standard <- ifelse(is.na(occ$Ctrl_recordNumber_Standard) |
                                                   occ$Ctrl_recordNumber_Standard=='',"",occ$Ctrl_recordNumber_Standard  %>% strtoi())
   # occ$Ctrl_recordNumber_Standard <- ifelse(is.na(occ$Ctrl_recordNumber_Standard),"",occ$Ctrl_recordNumber_Standard)

   # occ$Ctrl_recordNumber_Standard

   # tirar o NA do numero
   occ$Ctrl_recordNumber_Standard <- ifelse(is.na(occ$Ctrl_recordNumber_Standard),'',occ$Ctrl_recordNumber_Standard)

   occ$Ctrl_key_family_recordedBy_recordNumber <- ""
   occ <- occ %>%
      dplyr::mutate(Ctrl_key_family_recordedBy_recordNumber =
                       paste(Ctrl_family %>% toupper() %>% glue::trim(),
                             Ctrl_nameRecordedBy_Standard,
                             Ctrl_recordNumber_Standard,
                             # Ctrl_recordNumber,

                             # Ctrl_year,
                             # Ctrl_standardized_stateProvince,
                             sep='_'))

   occ$Ctrl_key_year_recordedBy_recordNumber <- ""
   occ <- occ %>%
      dplyr::mutate(Ctrl_key_year_recordedBy_recordNumber =
                       paste(ifelse(Ctrl_year %>% is.na() == TRUE, 'noYear',Ctrl_year)  %>% glue::trim(),
                             Ctrl_nameRecordedBy_Standard,
                             Ctrl_recordNumber_Standard,
                             sep='_'))

   # # numero de registros por frase saída in
   res_in <- occ %>% dplyr::count(paste0(Ctrl_key_family_recordedBy_recordNumber))
   colnames(res_in) <- c('Key',
                         'numberOfRecords')
   res_in <- res_in %>% dplyr::arrange_at(c('numberOfRecords'), desc )

   # print(occ$Ctrl_key_family_recordedBy_recordNumber %>% unique())
   return(list(occ = occ,
               summary = res_in,
               MainCollectorLastNameDB_new=collectorDictionary_checked_new))

}

