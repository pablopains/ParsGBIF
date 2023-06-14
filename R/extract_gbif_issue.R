#' @title extract_gbif_issue
#'
#' @name extract_gbif_issue
#'
#' @description Extract gbif issue
#'
#' @param occ GBIF occurrence table with selected columns as select_gbif_fields(columns = 'standard')
#' @param enumOccurrenceIssue An enumeration of validation rules for single occurrence records by GBIF file, if NA, will be used, data(EnumOccurrenceIssue)
#'
#' @details https://gbif.github.io/parsers/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html
#'
#' @return
#' occ_gbif_issue,
#' summary
#'
#' @author Pablo Hendrigo Alves de Melo,
#'         Nadia Bystriakova &
#'         Alexandre Monro
#'
#' @seealso \code{\link[ParsGBIF]{prepare_gbif_occurrence_data}}, \code{\link[ParsGBIF]{select_gbif_fields}}
#'
#' @examples
#' \donttest{
#' # extract_gbif_issue()
#'
#' help(extract_gbif_issue)
#'
#' occ <- prepare_gbif_occurrence_data(gbif_occurrece_file =  'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt',
#'                                     columns = 'standard')
#'
#' data(EnumOccurrenceIssue)
#' head(EnumOccurrenceIssue)
#' colnames(EnumOccurrenceIssue)
#'
#' occ_gbif_issue <- extract_gbif_issue(occ = occ,
#'                                      enumOccurrenceIssue = NA)
#'
#' names(occ_gbif_issue)
#'
#' head(occ_gbif_issue$issueGBIFSummary)
#'
#' colnames(occ_gbif_issue$issueGBIFOccurrence)
#' head(occ_gbif_issue$issueGBIFOccurrence)
#' colnames(occ_gbif_issue$issueGBIFOccurrence)
#' }
#' @export
extract_gbif_issue <- function(occ = NA,
                               enumOccurrenceIssue = NA)
{
  require(dplyr)

  # criar estrutura de dados a partir do modelo
  {
    if (is.na(enumOccurrenceIssue))
    {
      data(EnumOccurrenceIssue)
    }else
    {
      EnumOccurrenceIssue <- enumOccurrenceIssue
    }

    issue_table <- data.frame(t(EnumOccurrenceIssue$Constant))
    colnames(issue_table) <- EnumOccurrenceIssue$Constant

    issue_key <- colnames(issue_table)
    issue_table[1:NROW(occ),issue_key] <- rep(FALSE, NROW(occ))
  }


  ic <- 1
  for(ic in 1:length(issue_key))
  {
    x_issue <- grepl(issue_key[ic], occ$Ctrl_issue)
    # any(x_issue==TRUE)
    # occ$Ctrl_issue[x_issue==TRUE]
    issue_table[,ic] <- x_issue

  }

  issue_result <- data.frame(issue = issue_key,
                             n_occ = rep(0,length(issue_key)))

  i=1
  for(i in 1:length(issue_key))
  {
    n_occ <- issue_table[,issue_key[i]] %>% sum()
    # print(paste0(issue_key[i], ' - ',  n_occ))
    issue_result$n_occ[i] <- issue_table[,issue_key[i]] %>% sum()
  }

  issue_result <- issue_result %>%
    dplyr::arrange(desc(n_occ))

  # issueGBIFSummary <<- issue_result
  # issueGBIFOccurrence <<- issue_table

  return(list(occ_gbif_issue=issue_table,
              summary=issue_result))

}
