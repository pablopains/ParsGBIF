####################################################################################################
#                                                                                                  #
# Last Name Collector                                                                              #
#                                                                                                  #
# Pablo Hendrigo Alves de Melo (pablopains@yahoo.com.br)                                           #  
#                                                                                                  #
# Last update : 11-02-2020                                                                         #  
####################################################################################################

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

# x<- occ[['all']]$Ctrl_recordedBy[21]
# x
# get_lastNameRecordedBy(x)


# # # x<- occ[['all']]$Ctrl_recordedBy[2142]
# # 2116 ok 
# # 2117 no
# x<- occ[['all']]$Ctrl_recordedBy[24103]
# # lastNameRecordedBy(x)
# # x=';'
# # x
# 
# 46406
# 
# 40738 pegar o ultimo nome
# 40745
# 28869
# 17890 "Rafaela C. Forzza"
# 870
# 
# 31382 esse esta certo, pega o ultimo nome
# 
# 47273 reflora
# 
# 
# 353	UFGD
# 248 pega o M
# 
# 427	Aparecida
# 
# 1626	Douglas	Douglas C. Daly, C.A. Cid Ferreira, J. (aqui funcionma 2804	Daly	Douglas C. Daly;)
# 2324	30	Heloisa G. Dantas HGD-PG 30;Robson D. Ribeiro,D
# 2922	C	J.R.C;R.C.C
# 
# 
# 44171	OCGoes	O.C.Goés; D.Constantino
# 
# # nao e erro so ajuste 
# 3204	Sobr°	J.P.Lanna Sobr°;
# 
# pega o primeiro
# 16097	Ademir	Ademir Reis; Cassio Daltrini, Renata Menin & Vanderl
# 
# pega o maior
# 19432	Adolpho	Walter Adolpho Ducke; b.1876; d.1959; Ducke
# 16484	Agnaldo	Agnaldo de Mattos
# 47175	Alexander	Boris Alexander Krukoff
# 2187	Altamiro	Altamiro Barbosa;
# 
# 9559	Anderson	Anderson Cássio Sevilha
# 2034 Anderson	Anderson Cássio Sevilha;Anderson C  ssio Sevilha
# 30544	Antenor	Antenor Rego
# 
# 427	Aparecida	Aparecida da Silva, M;et al.
# 1923	Aparecida	M.Aparecida da Silva;R.C. Mendonça,E. Cardoso,
# 
# # para verificar
# 12163	Arantes	Arantes, A.A.; Cardoso, 
# 
# 
# 277	Labiak	T.M. Burda T.A. Maciel B.R. Marti
# 745	Amaral	I. L. do Amaral;et al
# 
# Anonymous
# 
# x <- occ[['all']]$Ctrl_recordedBy[277]
# x
# lastNameRecordedBy(x)


# 
# 
# # memory
# rm(list = ls())
# memory.limit(size = 1.75e13)
# 
# # diret?rio temporario de processamento do R 
# tempdir <- function() "D:\\temps"
# unlockBinding("tempdir", baseenv()) 
# assignInNamespace("tempdir", tempdir, ns="base", envir=baseenv())
# assign("tempdir", tempdir, baseenv())
# lockBinding("tempdir", baseenv())
# tempdir()
# 
# 
# if(!require(pacman)) install.packages("pacman")
# pacman::p_load(data.table,
#                stringr,
#                raster,
#                monographaR)
# 
# par(mar=c(1,1,1,1))
# 
# path_in <- 'C:\\Users\\pablo\\Dropbox\\BEPE\\Kew\\keyWord' 
# setwd(path_in)
# 
# keyword_all <- fread('I_keyword_all.txt', sep = ';')
# 
# 
# coletor <- NULL
# coletor$sobrenomerecordedBy <- rep("",nrow(keyword_all))
# coletor$sobrenomerecordedBy2 <- rep("",nrow(keyword_all))
# nrow(keyword_all)
# for( s in 1:nrow(keyword_all))
# {
#   coletor$sobrenomerecordedBy[s] <- pegaSobrenomeColetor(keyword_all$recordedBy[s])  
#   print(s)  
#   
# }  
# 
# 
# coletor$sobrenomerecordedBy2 <- iconv(coletor$sobrenomerecordedBy, to="latin1", from="utf-8")
# 
# x <- data.frame(id = keyword_all$id,
#                 recordedBy = keyword_all$recordedBy,
#                 sobrenomerecordedBy = coletor$sobrenomerecordedBy,
#                 sobrenomerecordedBy2 = coletor$sobrenomerecordedBy,
#                 recordNumber = keyword_all$recordNumber,
#                 sobrenomePadraorecordedBy = toupper(coletor$sobrenomerecordedBy),
#                 year = keyword_all$year,
#                 atualiza = rep('s',nrow(keyword_all)),
#                 stringsAsFactors = F)
# 
# x <- x[order(x$sobrenomerecordedBy2, x$recordNumber, decreasing = T),]
# 
# fwrite(x, 'I.I_keyword_all_prepara_coletor.txt', sep = ';')
# 
# #####################################################################################################
# 
# keyword_all <- fread('C:\\Users\\pablo\\Dropbox\\BEPE\\Kew\\keyWord\\I_keyword_all.txt')
# x <- fread('C:\\Users\\pablo\\Dropbox\\BEPE\\Kew\\keyWord\\I.I_keyword_all_prepara_coletor.txt')
# 
# # x1 <- x[, c('id','sobrenomePadraorecordedBy')]
# # colnames(x1) <- c('id_ck','lastNameRecordedBy')
# 
# x1 <- x[, c('sobrenomePadraorecordedBy')]
# colnames(x1) <- c('lastNameRecordedBy')
# 
# keyword_all <- cbind(x1,keyword_all)
# fwrite(keyword_all, 'C:\\Users\\pablo\\Dropbox\\BEPE\\Kew\\keyWord\\II_keyword_all_lastNameRecordedBy.txt', sep = ';')
# 
# #####################################################################################################

