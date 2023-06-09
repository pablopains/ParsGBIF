% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/update_collectorsDictionary.R
\encoding{UTF-8}
\name{update_collectorsDictionary}
\alias{update_collectorsDictionary}
\title{Create a key to group duplicates of a sample}
\usage{
update_collectorsDictionary(
  occ = NA,
  collectorDictionary_checked_file = NA,
  collectorDictionary_file =
    "https://raw.githubusercontent.com/pablopains/ParsGBIF/main/collectorDictionary/CollectorsDictionary.csv"
)
}
\arguments{
\item{occ}{GBIF occurrence table with selected columns as select_gbif_fields(columns = 'standard')}

\item{collectorDictionary_checked_file}{Verified collector dictionary file - point to a file on your local disk}

\item{collectorDictionary_file}{Collector dictionary file - point to a file on your local disk or upload via git at https://raw.githubusercontent.com/pablopains/ParsGBIF/main/collectorDictionary/CollectorsDictionary.csv.}
}
\value{
list with three data frames:
occ_collectorsDictionary, with update result fields only,
summary and
CollectorsDictionary_add, with new collectors that can be added to the
collector dictionary that can be reused in the future.
}
\description{
Include recordedByStandardized field with verified main collector's last name.
Include recordNumber_Standard field with only numbers from recordNumber.
Create a key to group duplicates in the key_family_recordedBy_recordNumber field,
composed of the fields: family + recordedByStandardized + recordNumber_Standard.
}
\details{
Fields created for each incident record:
nameRecordedBy_Standard,
recordNumber_Standard,
key_family_recordedBy_recordNumber,
key_year_recordedBy_recordNumber
}
\examples{
\donttest{
collectorsDictionaryFromDataset <- prepare_lastNameRecordedBy(occ=occ,
                                                              collectorDictionary_checked_file='collectorDictionary_checked.csv')
}

}
\seealso{
\code{\link[ParsGBIF]{select_gbif_fields}}, \code{\link[ParsGBIF]{prepare_collectorsDictionary}}
}
\author{
Pablo Hendrigo Alves de Melo,
Nadia Bystriakova &
Alexandre Monro
}
