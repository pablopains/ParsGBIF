#' @title extract_gbif_issue
#' @name extract_gbif_issue
#'
#' @description Extract gbif issue
#'
#' @param occ GBIF occurrence file with selected columns
#' @param EnumOccurrenceIssue An enumeration of validation rules for single occurrence records by GBIF file, if NA, will be used, data(EnumOccurrenceIssue)
#'
#' @details https://gbif.github.io/parsers/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html
#'
#' @return
#' issueGBIFSummary,
#' issueGBIFOccurrence
#'
#' @author Pablo Hendrigo Alves de Melo
#' @author Nadia Bystriakova
#' @author Alexandre Monro
#'
#' @seealso \code{\link[utils]{unzip}}, \code{\link[unzip]{read.table}}
#'
#' @examples
#' extract_gbif_issue <- function(occ = occ,
#'                                EnumOccurrenceIssue = NA)
#' @export
extract_gbif_issue <- function(occ = NA,
                               EnumOccurrenceIssue = NA)
{

  # criar estrutura de dados a partir do modelo
  {
    if (is.na(EnumOccurrenceIssue))
    {
      data(EnumOccurrenceIssue)
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


  issueGBIFSummary <<- issue_result
  issueGBIFOccurrence <<- issue_table

  return(list(issueGBIFSummary=issue_result,
              issueGBIFOccurrence=issue_table))

}
