get_data_from_osf = function(link){
  #' 
  #' @title download data from osf
  #' 
  #' @param link url to the (public) url
  #' 
  #' @return invisible NULL
  
  my_project <- osfr::osf_retrieve_node(link)
  
  my_files <- osfr::osf_ls_files(my_project)
  
  osfr::osf_download(my_files)
  
  return(invisible())
}