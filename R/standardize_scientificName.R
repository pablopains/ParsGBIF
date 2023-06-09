#' @title standardize_scientificName
#' @name standardize_scientificName
#'
#' @description standardize binomial name, variety, subspecies, form and hybrids, authorship
#' to allow comparison with names of taxa in the World Checklist of Vascular Plants (WCVP) database
#'
#' @param searchedName scientific name, with or without author
#'
#' @details Standardize scientific name according to WCVP format.
#' Separate generic epithet, specific epithet, variety, subspecies, form, hybrid and author, in the scientific name, if any.
#' Standardize, according to WCVP, abbreviation of infrataxon, if any:
#' variety to var.,
#' subspecies to subsp.,
#' FORM to f.,
#' hybrid separator separate x from the specific epithet.
#'
#' @return
#' searchedName,
#' standardizeName,
#' taxonAuthors,
#' taxonAuthors_last
#'
#' @author Pablo Hendrigo Alves de Melo,
#'         Nadia Bystriakova &
#'         Alexandre Monro
#'
#' @seealso \code{\link[ParsGBIF]{get_wcvp}}, \code{\link[ParsGBIF]{checkName_wcvp}}
#'
#' @examples
#' \donttest{
#' # standardize_scientificName()
#'
#' help(standardize_scientificName)
#'
#' standardize_scientificName('Leucanthemum ×superbum (Bergmans ex J.W.Ingram) D.H.Kent')
#' standardize_scientificName('Alomia angustata (Gardner) Benth. ex Baker')
#' standardize_scientificName('Centaurea ×aemiliae Font Quer')
#' }
#'
#' @export
standardize_scientificName <- function(searchedName = 'Alomia angustata (Gardner) Benth. ex Baker')
{
  require(stringr)

  x <- {}

  infrataxa = ''

  searchedName_raw <- searchedName
  searchedName_ori <- searchedName

  sp <- stringr::str_split(searchedName, ' ', simplify = T)
  padrao <- c('var.', 'subsp.', ' f. ')
  padrao_s <- c('var.', 'subsp.', 'f.')

  if(length(sp)>1)
  {
    if(grepl(padrao[1],searchedName, fixed = T)|grepl(padrao[2],searchedName, fixed = T)|grepl(padrao[3],searchedName, fixed = T) )
    {
      ip <- 1
      for(ip in 1:length(padrao))
      {
        if(grepl(padrao[ip],searchedName, fixed = T)==TRUE)
        {
          indx <- sp == padrao_s[ip]

          if(length(sp)>3){if(indx[3]==T){infrataxa <- sp[4]}}
          if(length(sp)>4){if(indx[4]==T){infrataxa <- sp[5]}}
          if(length(sp)>5){if(indx[5]==T){infrataxa <- sp[6]}}
          if(length(sp)>6){if(indx[6]==T){infrataxa <- sp[7]}}
          if(length(sp)>7){if(indx[7]==T){infrataxa <- sp[8]}}
          if(length(sp)>8){if(indx[8]==T){infrataxa <- sp[9]}}
          if(length(sp)>9){if(indx[9]==T){infrataxa <- sp[10]}}
          if(length(sp)>10){if(indx[10]==T){infrataxa <- sp[11]}}
          if(length(sp)>11){if(indx[11]==T){infrataxa <- sp[12]}}
          if(length(sp)>12){if(indx[12]==T){infrataxa <- sp[13]}}

          if(str_detect(searchedName_raw, '×')==TRUE)
          {
            searchedName <- paste0(sp[1], ' × ', sp[3], ifelse(infrataxa=='','',paste0(' ', padrao_s[ip], ' ', infrataxa)))
          }else
          {
            searchedName <- paste0(sp[1], ' ', sp[2], ' ', padrao_s[ip], ' ', infrataxa)
          }

          break

        }
      }
    }else
    {

      if(str_detect(searchedName_raw, '×')==TRUE)
      {

        if(str_detect(sp[2], '×')==TRUE)
        {
          searchedName <- sub('×','× ',searchedName)
          sp <- stringr::str_split(searchedName, ' ', simplify = T)
        }

        searchedName <- paste0(sp[1], ' × ', sp[3])

      }else
      {
        if((str_sub(sp[2],1,1)==toupper(str_sub(sp[2],1,1)) |
            str_sub(sp[2],1,1)=="(") )
        {
          searchedName <- sp[1]
        }else
        {
          searchedName <- paste0(sp[1], ' ', sp[2])
        }
      }
    }
  }else
  {
    searchedName <- sp[1]
  }

  sp2 <- stringr::str_split(searchedName, ' ', simplify = T)

  taxon_authors <- str_sub(searchedName_ori, str_locate(searchedName_ori, sp2[length(sp2)])[2]+2, nchar(searchedName_ori))

  if(length(sp2)==4 &!is.na(taxon_authors)){if(paste0(sp2[3], ' ',sp2[4])==taxon_authors){taxon_authors <- ''}}

  xi <- str_locate(taxon_authors,'\\(')
  xf <- str_locate(taxon_authors,'\\)')


  if(!is.na(xi)[1] & nchar(taxon_authors) > 0)
  {
    if(xi[1]==1)
    {
      taxon_authors_last <- str_sub(taxon_authors,xf[2]+ifelse(str_sub(taxon_authors,xf[2]+1,xf[2]+1)==' ',2,1),nchar(taxon_authors))
    }
  }else
  {
    taxon_authors_last <- ''
  }

  return(list(searchedName = searchedName_raw,
              standardizeName = searchedName,
              taxonAuthors= taxon_authors,
              taxonAuthors_last= taxon_authors_last))
}
