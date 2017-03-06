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
#' @export

getOS_auth <- function(user=as.character(), key=as.character(),
                       complete=TRUE, by=6:8) {
  # Get and order data ---------------------------
  response <- RCurl::getURL(paste0("https://", user, ":", key,
                            "@opensky-network.org/api/states/all"))
  lresponse <- RJSONIO::fromJSON(response, nullValue = NA)
  m_response <- matrix(unlist(unlist(lresponse$states)),
                       nrow = length(lresponse$states),
                       byrow = T)
  col_names <- c("icao24", "callsign", "origin_country", "time_position",
                 "time_velocity", "longitude", "latitude", "altitude",
                 "on_ground", "velocity", "heading", "vertical_rate")
  df_response <- as.data.frame(m_response, stringsAsFactors = FALSE)
  colnames(df_response) <- col_names
  df_response[] <- lapply(df_response, type.convert)
  df_response<-df_response[,1:12]
  # Filter data if necessary ---------------------------
  if (isTRUE(complete)){
    vector_sel <- complete.cases(df_response[, by])
    df_response<-df_response[vector_sel, ]
  }

  return(df_response)
}
