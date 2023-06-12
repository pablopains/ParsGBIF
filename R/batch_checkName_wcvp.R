#' @title batch_checkName_wcvp
#' @name batch_checkName_wcvp
#'
#' @description Use the World Checklist of Vascular Plants (WCVP) database
#' to check accepted names and update synonyms, in batch
#'
#' @param occ GBIF occurrence table with selected columns as select_gbif_fields(columns = 'standard')
#' @param wcvp_names WCVP table, wcvp_names.csv file from http://sftp.kew.org/pub/data-repositories/WCVP/
#' @param if_author_fails_try_without_combinations option for partial verification of the authorship of the species. Remove the authors of combinations, in parentheses
#' @param wcvp_selected_fields WCVP fields selected as return, 'standard' basic columns, 'all' all available columns
#'
#' @details See help(checkName_wcvp) and https://powo.science.kew.org/about-wcvp
#'
#' @return
#' occ_checkName_wcvp:
#'   wcvp_plant_name_id,
#'   wcvp_taxon_rank,
#'   wcvp_taxon_status,
#'   wcvp_family,
#'   wcvp_taxon_name,
#'   wcvp_taxon_authors,
#'   wcvp_accepted_plant_name_id,
#'   wcvp_reviewed,
#'   wcvp_searchedName,
#'   wcvp_taxon_status_of_searchedName,
#'   wcvp_plant_name_id_of_searchedName,
#'   wcvp_taxon_authors_of_searchedName,
#'   wcvp_verified_author,
#'   wcvp_verified_speciesName,
#'   wcvp_searchNotes
#' summary
#'
#' @author Pablo Hendrigo Alves de Melo
#'         Nadia Bystriakova
#'         Alexandre Monro
#'
#' @seealso \code{\link[ParsGBIF]{get_wcvp}}, \code{\link[ParsGBIF]{checkName_wcvp}}
#'
#' @examples
#' # load package
#' library(ParsGBIF)
#'
#' help(batch_checkName_wcvp)
#'
#' wcvp_names <- get_wcvp(read_only_to_memory = TRUE)$wcvp_names
#'
#' occ <- prepare_gbif_occurrence_data(gbif_occurrece_file =  'https://raw.githubusercontent.com/pablopains/ParsGBIF/main/dataGBIF/Achatocarpaceae/occurrence.txt',
#'                                     columns = 'standard')
#'
#' res_batch_checkName_wcvp <- batch_checkName_wcvp(occ = occ,
#'                                                  wcvp_names =  wcvp_names,
#'                                                  if_author_fails_try_without_combinations = TRUE,
#'                                                  wcvp_selected_fields = 'standard')
#'
#' names(res_batch_checkName_wcvp)
#'
#' head(res_batch_checkName_wcvp$wcvpSummary)
#'
#' head(res_batch_checkName_wcvp$wcvpOccurrence)
#' @export
batch_checkName_wcvp <- function(occ = NA,
                                 wcvp_names =  wcvp_names,
                                 if_author_fails_try_without_combinations = TRUE,
                                 wcvp_selected_fields = 'standard')
{
  # https://powo.science.kew.org/about-wcvp

  require(dplry)
  require(stringr)
  require(tidyselect)

  if(!wcvp_selected_fields %in% c('standard','all'))
  {
    stop("Unknown option!")
  }


  if (wcvp_selected_fields == 'standard')
  {
    wcvp_na <- data.frame(wcvp_plant_name_id  = NA,
                          # wcvp_ipni_id = NA,
                          wcvp_taxon_rank = NA,
                          wcvp_taxon_status = NA,
                          wcvp_family = NA,
                          # wcvp_genus_hybrid = NA,
                          # wcvp_genus = NA,
                          # wcvp_species_hybrid = NA,
                          # wcvp_species = NA,
                          # wcvp_infraspecific_rank = NA,
                          # wcvp_infraspecies = NA,
                          # wcvp_parenthetical_author = NA,
                          # wcvp_primary_author = NA,
                          # wcvp_publication_author = NA,
                          # wcvp_place_of_publication = NA,
                          # wcvp_volume_and_page = NA,
                          # wcvp_first_published = NA,
                          # wcvp_nomenclatural_remarks = NA,
                          # wcvp_geographic_area = NA,
                          # wcvp_lifeform_description = NA,
                          # wcvp_climate_description = NA,
                          wcvp_taxon_name = NA,
                          wcvp_taxon_authors = NA,
                          wcvp_accepted_plant_name_id = NA,
                          # wcvp_basionym_plant_name_id = NA,
                          # wcvp_replaced_synonym_author = NA,
                          # wcvp_homotypic_synonym = NA,
                          # wcvp_parent_plant_name_id = NA,
                          # wcvp_powo_id = NA,
                          # wcvp_hybrid_formula = NA,
                          wcvp_reviewed = NA,
                          # # wcvp_TAXON_NAME_U = NA,
                          wcvp_searchedName = NA,
                          wcvp_taxon_status_of_searchedName = NA,
                          wcvp_plant_name_id_of_searchedName = NA,
                          wcvp_taxon_authors_of_searchedName = NA,
                          wcvp_verified_author = NA,
                          wcvp_verified_speciesName = NA,
                          wcvp_searchNotes = NA)
  }

  if (wcvp_selected_fields == 'all')
  {
    wcvp_na <- data.frame(wcvp_plant_name_id  = NA,
                          wcvp_ipni_id = NA,
                          wcvp_taxon_rank = NA,
                          wcvp_taxon_status = NA,
                          wcvp_family = NA,
                          wcvp_genus_hybrid = NA,
                          wcvp_genus = NA,
                          wcvp_species_hybrid = NA,
                          wcvp_species = NA,
                          wcvp_infraspecific_rank = NA,
                          wcvp_infraspecies = NA,
                          wcvp_parenthetical_author = NA,
                          wcvp_primary_author = NA,
                          wcvp_publication_author = NA,
                          wcvp_place_of_publication = NA,
                          wcvp_volume_and_page = NA,
                          wcvp_first_published = NA,
                          wcvp_nomenclatural_remarks = NA,
                          wcvp_geographic_area = NA,
                          wcvp_lifeform_description = NA,
                          wcvp_climate_description = NA,
                          wcvp_taxon_name = NA,
                          wcvp_taxon_authors = NA,
                          wcvp_accepted_plant_name_id = NA,
                          wcvp_basionym_plant_name_id = NA,
                          wcvp_replaced_synonym_author = NA,
                          wcvp_homotypic_synonym = NA,
                          wcvp_parent_plant_name_id = NA,
                          wcvp_powo_id = NA,
                          wcvp_hybrid_formula = NA,
                          wcvp_reviewed = NA,
                          # wcvp_TAXON_NAME_U = NA,
                          wcvp_searchedName = NA,
                          wcvp_taxon_status_of_searchedName = NA,
                          wcvp_plant_name_id_of_searchedName = NA,
                          wcvp_taxon_authors_of_searchedName = NA,
                          wcvp_verified_author = NA,
                          wcvp_verified_speciesName = NA,
                          wcvp_searchNotes = NA)
  }


  index <- occ$Ctrl_taxonRank %>% toupper() %in%
    toupper(c('SPECIES',
              'VARIETY',
              'SUBSPECIES',
              'FORM'))

  colunas_wcvp_sel <- colnames(wcvp_na)

  occ_all <- cbind(occ, wcvp_na) %>%
    dplyr::mutate(wcvp_searchedName = Ctrl_scientificName) %>%
    dplyr::select(tidyselect::all_of(colunas_wcvp_sel))

  name_search_wcvp <- occ_all[index==TRUE,]$wcvp_searchedName %>% unique() %>% as.character()

  # https://powo.science.kew.org/about-wcvp#unplacednames

  x <- {}
  i <- 1
  tot_rec <- NROW(name_search_wcvp)

  for(i in 1:tot_rec)
  {
    sp_tmp <- name_search_wcvp[i]

    print( paste0( i, '-',tot_rec ,' ',  sp_tmp))

    x_tmp <- checkName_wcvp(searchedName = sp_tmp,
                            wcvp_names = wcvp_names,
                            if_author_fails_try_without_combinations = TRUE)

    x <- rbind(x,
               cbind(x_tmp[,
                           tidyselect::all_of(colunas_wcvp_sel)]))


    # n_reg <- NROW(occ_all[index==TRUE,])
    # print( str_c( i, ' - WCVP: ', name_search_wcvp[i], ' : ',n_reg, ' registros - ', ifelse(is.na(x_tmp$wcvp_taxon_name),'',x_tmp$wcvp_taxon_name),' ',x_tmp$wcvp_verified_author,' ',x_tmp$wcvp_verified_speciesName ,' : ', x_tmp$wcvp_searchNotes))


    index <- occ_all$wcvp_searchedName %in% sp_tmp #name_search_wcvp[i]  # wcvp_searchedName == Ctrl_scientificName
    occ_all[index==TRUE, tidyselect::all_of(colunas_wcvp_sel)] <- x_tmp[, tidyselect::all_of(colunas_wcvp_sel)]

    # # aqui
    # print( str_c( i, '-',tot_rec , ' - WCVP: ', sp_tmp,' -> ' ,ifelse(is.na(x_tmp$wcvp_taxon_name),'',x_tmp$wcvp_taxon_name),' ',x_tmp$wcvp_verified_author,' ',x_tmp$wcvp_verified_speciesName ,' : ', x_tmp$wcvp_searchNotes))

    # japrocessado[i] <- TRUE
  }

  return(list(occ_checkName_wcvp=occ_all[,tidyselect::all_of(colunas_wcvp_sel)],
              summary=x))
}
