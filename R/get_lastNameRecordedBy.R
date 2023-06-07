#' @title get_lastNameRecordedBy
#' @name get_lastNameRecordedBy
#'
#' @description Returns the last name of the main collector
#'
#' @param x recordedBy field
#'
#' @details Returns the last name of the main collector in recordedBy field
#'
#' @return
#' last name of the main collector
#'
#' @author Pablo Hendrigo Alves de Melo
#' @author Nadia Bystriakova
#' @author Alexandre Monro
#'
#' @seealso \code{\link[ParsGBIF]{prepere_lastNameRecordedBy}}, \code{\link[ParsGBIF]{update_lastNameRecordedBy}}
#'
#' @examples
#' help(get_lastNameRecordedBy)
#'
#' get_lastNameRecordedBy('Melo, P.H.A & Monro, A.')
#'
#' get_lastNameRecordedBy('Monro, A. & Melo, P.H.A')
#' @export
get_lastNameRecordedBy <- function(x)
{

   #aqui
   # x = gsub("et al.","",x, fixed=TRUE) # teste pablo 10-02-2020
   # x = gsub("et. al.","",x, fixed=TRUE) # teste pablo 10-02-2020
   # x = gsub("et al","",x, fixed=TRUE) # teste pablo 10-02-2020
   # x = gsub("s.c.","",x, fixed=TRUE) # teste pablo 10-02-2020
   # x = gsub("s/c","",x, fixed=TRUE) # teste pablo 10-02-2020
   # x = gsub("sc","",x, fixed=TRUE) # teste pablo 10-02-2020


   x = gsub("[?]","",x) # teste pablo 10-02-2020

   x = gsub("[.]"," ",x) # teste pablo 10-02-2020

   if (length(grep("\\|",x))>0)
   {
      x = strsplit(x,"\\|")[[1]][1]
   }

   x = gsub("[á|à|â|ã|ä]","a",x)
   x = gsub("[Á|À|Â|Ã|Ä]","A",x)

   x = gsub("[ó|ò|ô|õ|ö]","o",x)
   x = gsub("[Ó|Ò|Ô|Õ|Ö]","O",x)

   x = gsub("[í|ì|î|ï]","i",x)
   x = gsub("[Í|Ì|Î|Ï]","I",x)

   x = gsub("[ú|ù|û|ü]","u",x)
   x = gsub("[Ú|Ù|Û|Ü]","U",x)

   x = gsub("[é|è|ê|ë]","e",x)
   x = gsub("[É|È|Ê|Ë]","E",x)

   x = gsub("ñ","n",x)
   x = gsub("Ñ","N",x)

   x = gsub("ç","c",x)
   x = gsub("Ç","C",x)

   x = gsub("\\(|\\)"," ",x) # teste pablo 10-02-2020
   x = gsub("\\[|\\]"," ",x) # teste pablo 10-02-2020
   x = gsub("[\"]"," ",x) # teste pablo 10-02-2020

   #pega o primeiro nome de uma lista de coletores separados por & se houver
   if (length(grep("&",x))>0)
   {
      x = strsplit(x,"&")[[1]][1]
   }

   #pega o primeiro nome de uma lista de coletores separados por ";" se houver
   if (length(grep(";",x))>0)
   {
      x_t <- strsplit(x,";")[[1]][1]

      # para capturar padrão iniciado por ;
      if (nchar(x_t)==0)
      {
         x_t <- strsplit(x,";")[[1]][2]
         if (is.na(x_t )) { x_t <- ""}
      }

      if (nchar(x_t)>0)
      {
         x <- x_t
      } else
      {
         x <- ''
      }

   }
   #se houver v?rgula pode ser dois casos:
   #1. ou o valor antes da v?rgula ? o sobrenome (padr?o INPA)
   #2. ou a v?rgula esta separando diferentes coletores (e neste caso as palavras do primeiro elemento n?o s?o apenas abrevia??es)

   # aqui
   # vl = grep(",|.",x)

   vl = grep(",| ",x)

   #se tem v?rgula
   if (length(vl)>0) {

      # aqui 2 se der pau voltar
      # x = gsub("[.]"," ",x) # teste pablo 10-02-2020

      #separa pela v?rgula e pega o primeiro elemento
      xx = strsplit(x,",")[[1]][1]

      #separa o primeiro elemento antes da v?rgula por espa?os
      xx = strsplit(xx," ")[[1]]

      #apaga elementos vazios
      xx = xx[xx!=""]

      #se o numero de caracteres da maior palavra for maior do que 2, ent?o o primeiro elemento era todo o nome do coletor, pega apenas o sobrenome
      if (max(nchar(xx))>2) {
         #1 pegue esta palavra como sobrenome se houver apenas 1 palavra
         vll = which(nchar(xx)==max(nchar(xx)))
         #ou 2, se houver mais de uma palavra com o mesmo tamanho, pega a ?ltima delas
         if (length(vll)>1) {
            vll = vll[length(vll)]
         }
         sobren = xx[vll]
         # ##############
         #       # teste para pegar o ultimo nome
         #       #1 pegue esta palavra como sobrenome se houver apenas 1 palavra
         #       sobren = xx[[length(nchar(xx))]]
         # ##############
         #
      } else {
         #caso contrario h? apenas abrevia??es em xx, ent?o, virgula separa apenas sobrenome de abreviacoes ou prenome
         sb = strsplit(x,",")[[1]]
         sb = str_trim(sb)
         nsb = nchar(sb)
         sbvl = which(nsb==max(nsb))
         if (length(sbvl)>1) {
            sbvl = sbvl[length(sbvl)]
         }
         sobren = sb[sbvl]
      }
   } else {
      #neste caso n?o h? virgula, ent?o o ultimo nome ? o sobrenome
      xx = strsplit(x," ")[[1]]
      sobren = xx[length(xx)]
   }
   sobren = str_trim(sobren)
   sobren = gsub("?","", sobren)
   sobren = paste(sobren,sep="-")
   if (length(sobren)>0){
      x = strsplit(sobren,"\\|")[[1]]
      sobren = x[1]
      #print(sobren)
      return(sobren)
   } else {
      return(NA)
   }
}

