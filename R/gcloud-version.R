#' Gcloud version
#'
#' Get version of Google Cloud SDK components.
#'
#' @return a list with the version of each component.
#'
#' @export
gcloud_version <- function() {
  out <- gcloud_exec("version", echo = FALSE)
  version <- strsplit(unlist(strsplit(out$stdout, "\r?\n")),
                      " (?=[^ ]+$)", perl = TRUE)
  v_numbers <- lapply(version, function(x) numeric_version(x[2]))
  names(v_numbers) <- sapply(version, function(x) x[1])

  v_numbers
}
