#' @title prepare_gbif_occurrence_data
#' @name prepare_gbif_occurrence_data
#'
#' @description Prepare occurrence data from GBIF to use in package
#'
#' @param gbif_occurrece_file the name of the file which the data are to be read from.
#' Either a path to a file, a connection, or literal data (either a single string or a raw vector)
#' @param columns 'standard' by default. See select_gbif_fields() function.
#' *'standard' basic columns about what, when, where, and who collected,
#' *'all' all available columns
#' *or list column names
#' @details Prepare occurrence data from GBIF to use in package.
#' Select the data fields to be used.
#' Add "Ctrl_" at the beginning of each field name
#'
#' @return
#' data.frame with fields selected by the select_gbif_fields function and with "Ctrl_" at the beginning of each field name
#'
#' @author Pablo Hendrigo Alves de Melo,
#'         Nadia Bystriakova &
#'         Alexandre Monro
#'
#' @seealso \code{\link[ParsGBIF]{select_gbif_fields}}, \code{\link[ParsGBIF]{extract_gbif_issue}}
#'
#' @importFrom readr read_delim
#'
#' @examples
#' \donttest{
#' # prepare_gbif_occurrence_data()
#'
#' help(prepare_gbif_occurrence_data)
#'
#' occ <- prepare_gbif_occurrence_data(gbif_occurrece_file =
#' 'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt',
#'                                     columns = 'standard')
#'
#' colnames(occ)
#'
#' head(occ)
#' }
#' @export
prepare_gbif_occurrence_data <- function(gbif_occurrece_file = 'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt',
                                         columns = 'standard')
{

  occ <- readr::read_delim(file = gbif_occurrece_file,
                           delim = '\t',
                           locale = readr::locale(encoding = "UTF-8"),
                           show_col_types = FALSE)

  col_sel <- select_gbif_fields(columns = columns)

  occ <- occ[ ,col_sel]

  colnames(occ) <- paste0('Ctrl_',colnames(occ))

  return(occ)
}
