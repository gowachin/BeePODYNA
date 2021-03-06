#' BeePODYNA
#'
#' A package to study population dynamic.
#'
#' @docType package
#' @name beepodyna
NULL

#' beepodyna
#'
#' The \code{beepodyna} function creates a \code{R} object of the class \code{beepodyna}.
#'
#' @details The \code{beepodyna} object is a list containing a community, the corresponding interaction matrix
#' and a list of the functions to apply to each population, in the order they appear in the community object.
#'
#' @param label is the label of the \code{beepodyna} object.
#' @param community is the community object of class \code{community} to study
#' @param interactions is the interaction matrix of the class \code{interactions} between the populations of the community. Default is a matrix without interactions.
#' @param functions is a function or a list of functions to apply to each population in the same order as it is in the community.
#' If the length of the list is not the same as the community, the functions are repeated so the length of the list is the same as the number of populations.
#' @param verbose Default is \code{TRUE}. Set to \code{FALSE} if you don't want the warnings.
#'
#' @seealso \code{\link[BeePODYNA]{community}} and \code{\link[BeePODYNA]{interactions}} to create the object in parameters.
#'
#' @examples
#' hare = population("hirsuta",30,2,80)
#' lynx = population("daonensis",4,1.2,60)
#' hudson = community("hudson",hare,lynx)
#'
#' beepodyna(label="model_1",
#'           community=hudson,
#'           interactions=interactions(2),
#'           exponential_growth,
#'           verbose = FALSE
#'           )
#'
#' @author Nicolas BARTALUCCI <bartalucci.nico@gmail.com>
#'
#' @export
beepodyna <- function(label,
                      community,
                      interactions = interactions(length(community)),
                      functions = exponential_growth,
                      verbose = TRUE) {

  ### check the class of the parameters

  if (!is.character(label) ||
    length(label) > 1) {
    stop("Label must be a single charactere string")
  }

  if (class(community) != "community") {
    stop("The community given is not of the class community.")
  }
  if (class(interactions) != "interactions") {
    stop("The interactions matrix given is not of the class interactions")
  }

  if (class(functions) == "function")
    functions <- list(functions)

  if (class(functions) == "list") {
    not_func <- sapply(functions, class)

    if (any(not_func != "function"))
        stop(sprintf("The %d element of the functions list in not a function.",
                     which(not_func)[1]))
  } else {
    stop("The functions given are not a single function or a list.")
  }

  ### check the length of the parameters

  nb_pop <- length(community)

  if (nrow(interactions) != nb_pop) {
    stop("All the parameters haven't the same size.")
  }

  ###### checks asked for in ISSUE #3 ########################
  counts_function <- function(subpops, param){
    count <- length(subpops[[param]])
    return(count) }
  szs <- lapply(community[["populations"]], FUN = counts_function, param = "size")
  tms <- lapply(community[["populations"]], FUN = counts_function, param = "time")

  if(length(unique(szs)) > 1){
    if(verbose){
      warning("The length of sizes data is not the same for all of your populations.")
    }
  }
  if(length(unique(tms)) > 1){
    if(verbose){
      warning("The length of time data is not the same for all of your populations.")
    }
  }

  if(length(unique(tms)) != length(unique(szs))){

    for(i in (1:length(community[["populations"]]))){
      length_sizes <- length(community[["populations"]][[i]][["size"]])
      length_times <- length(community[["populations"]][[i]][["time"]])

      maximum_length <- ifelse( length_sizes > length_times, "s", "t")

      if(maximum_length == "t"){
        if(verbose){
          warning(paste0("The length of time data is higher than the number of size data for population ", i))
        }
        community[["populations"]][[i]][["size"]] <- c(
          community[["populations"]][[i]][["size"]],
          rep(NA, (length_times - length_sizes)))  # for filling first values
      }

      if(maximum_length == "s"){
        if(verbose){
          warning(paste0("The length of size data is higher than the number of time data for population ", i))
        }
        community[["populations"]][[i]][["time"]] <- c(
          community[["populations"]][[i]][["time"]],
          rep(NA, (length_sizes - length_times)))  # for filling first values]
      }
    }

  }




  if (length(functions) > nb_pop) {
    if (verbose) {
      warning("The functions list is too long comparing to the number of populations. The last functions of the list are not used.")
    }
    functions <- functions[1:nb_pop]
  }

  if (length(functions) < nb_pop) {
    if (verbose) {
      warning("The functions list has been repeted since its length doesn't match the number of population.")
    }
    functions <- rep(functions, ceiling(nb_pop / length(functions)))[1:nb_pop]
  }

  ### Create the beepodyna object
  structure(list(
    label = label,
    community = community,
    interactions = interactions,
    functions = functions
  ),
  class = "beepodyna"
  )
}


#' @export
length.beepodyna <- function(x) {
  length(x$community)
}
