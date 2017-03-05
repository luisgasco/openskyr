#' Get OpenSky data anonymously
#'
#' Allow to access OpenSky Network API without authentication. There are some
#' limitations:
#' \itemize{
#' \item Anonymous users can only get the most recent state vectors
#' \item Anonymous users can only retrieve data with a time resultion of 10 seconds
#' }
#' \href{https://opensky-network.org/apidoc/rest.html#limitiations-for-anonymous-unauthenticated-users}{More API information}
#'
#' @param complete TRUE if you want to get complete cases depending on "by" variable.
#' @param by A vector of numbers that specify the columns to take into account to complete cases.
#' By default the filter works on Latitude, Longitude and Altitude column
#' @return The sum of \code{x} and \code{y}.
#' @examples
#' data_completecases <- getOS_anom(TRUE,by=6:7)
#' data <- getOS_anom()
#' @export

getOS_anom <- function(complete=TRUE, by=6:8) {
  # Get and order data ---------------------------
  response <- RCurl::getURL("https://opensky-network.org/api/states/all")
  lresponse <- RJSONIO::fromJSON(response, nullValue = NA)
  m_response <- matrix(unlist(unlist(lresponse$states)),
                       nrow = length(lresponse$states),
                       byrow = T)
  col_names <- c("icao24", "callsign", "origin_country", "time_position",
                 "time_velocity", "longitude", "latitude", "altitude",
                 "on_ground", "velocity", "heading", "vertical_rate", "sensor")
  df_response <- as.data.frame(m_response, stringsAsFactors = FALSE)
  colnames(df_response) <- col_names

  # Filter data if necessary ---------------------------
  if (isTRUE(complete)){
    vector_sel <- complete.cases(df_response[, by])
    df_response<-df_response[vector_sel, ]
  }

  return(df_response)
}
