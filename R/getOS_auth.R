#'  Get OpenSky data authenticated
#'
#' Allow to access OpenSky Network API using your valid OpenSky account,
#' The rate limitations are:
#' \itemize{
#' \item OpenSky users can retrieve data of up to 1 hour in the past
#' \item OpenSky users can retrieve data with a time resultion of 5 seconds.
#' }
#' \href{https://opensky-network.org/apidoc/rest.html#limitiations-for-anonymous-unauthenticated-users}{More API information}
#' @param user A valid user of OpenSky Network .
#' @param key The password of the user specified before.
#' @inheritParams getOS_anom
#' @return A dataframe with every flight registered on OpenSky Network in real-time.
#' @examples
#' data_completecases <- getOS_auth("your_user","your_password",TRUE,by=6:7)
#' data <- getOS_auth("your_user","your_password")

getOS_auth <- function(user=as.character(), key=as.character(),
                       complete=TRUE, by=6:8) {
  # Get and order data ---------------------------
  response <- getURL(paste0("https://", user, ":", key,
                            "@opensky-network.org/api/states/all"))
  lresponse <- fromJSON(response, nullValue = NA)
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
    df_response <- complete.cases(df_response[, by])
  }

  return(df_response)
}
