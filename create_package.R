#' @details ParsGBIF - package  creation - Only in development times
{
  rm(list = ls())


  # EnumOccurrenceIssue <- readr::read_csv("C:/ParsGBIF/data/EnumOccurrenceIssue.csv",
  #                                        locale = readr::locale(encoding = "UTF-8"),
  #                                        show_col_types = FALSE)
  #
  # save(EnumOccurrenceIssue,
  #      file = "C:/ParsGBIF - github.com/data/EnumOccurrenceIssue.RData",
  #      ascii = TRUE)

  # install.packages("rcmdcheck")
  # install.packages("devtools")

  library(devtools)
  library(rcmdcheck)
  setwd("C:\\ParsGBIF - github.com")

  # create("ParsGBIF", rstudio = FALSE)

  devtools::load_all()
  devtools::document()

  # doc to CRAN
  # rcmdcheck::rcmdcheck(getwd())


  rm(list = ls())
  devtools::install_github("pablopains/ParsGBIF")
  library(ParsGBIF)

}
