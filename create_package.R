#' @details ParsGBIF - package  creation - Only in development times
{
  rm(list = ls())


  EnumOccurrenceIssue <- readr::read_csv("C:/ParsGBIF/data/EnumOccurrenceIssue.csv",
                                         locale = readr::locale(encoding = "UTF-8"),
                                         show_col_types = FALSE)

  save(EnumOccurrenceIssue,
       file = "C:/ParsGBIF - github.com/data/EnumOccurrenceIssue.RData",
       ascii = TRUE)


  EnumOccurrenceIssue <- readr::read_csv("C:/ParsGBIF/data/EnumOccurrenceIssue.csv",
                                         locale = readr::locale(encoding = "UTF-8"),
                                         show_col_types = FALSE)

  save(EnumOccurrenceIssue,
       file = "C:/ParsGBIF - github.com/data/EnumOccurrenceIssue.r",
       ascii = TRUE)


  library(devtools)
  setwd("C:\\ParsGBIF - github.com")

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

  help(select_gbif_fields)


  devtools::install_github("pablopains/ParsGBIF")
  library(ParsGBIF)

}
