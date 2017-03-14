#' Get your sensors' data
#'
#' Allow to access to vectors for your own sensors without any rate limitation.Note that authentication is required for this operation, otherwise you will
#' get a 403 - Forbidden.
#' \href{https://opensky-network.org/apidoc/rest.html#limitiations-for-anonymous-unauthenticated-users}{More API information}
#'
#' @inheritParams getOS_auth
#' @param serials A character vector with the serials codes of your receivers you want to retrieve
#' @return A dataframe with every flight registered on OpenSky Network in real-time, but only related
#' to your own sensors registered in the platform.
#' @examples
#' your_own_data <- getOS_own("your_user","your_password",
#' serials=c("your_sensor_serial1","your_sensor_serial2"))
#' your_own_data2 <- getOS_own("your_user","your_password",
#' serials="your_sensor_serial1")
#' your_own_data3 <- getOS_own("your_user","your_password")
#' @export

getOS_own <- function(user=as.character(), key=as.character(),
                      complete=TRUE, by=6:8, serials=as.vector()) {
  # Check inputs,get and order data ---------------------------
  if (!is.null(serials)){
    if (length(serials <= 1)){
      serials <- paste0("?serials=", serials)
    }else{
      serial1 <- paste0("?serials=", serials[1])
      serial2 <- paste0("&serials=", serials[2:length(serials)])
      serial2_j <- paste(serial2, collapse = "")
      serials <- paste(serial1, serial2_j, collapse = "")
    }

    response <- RCurl::getURL(paste0("https://", user, ":", key,
                              "@opensky-network.org/api/states/own", serials))
  }else{
    response <- RCurl::getURL(paste0("https://", user, ":", key,
                              "@opensky-network.org/api/states/own"))
  }
  lresponse <- RJSONIO::fromJSON(response, nullValue = NA)
  m_response < -matrix(unlist(unlist(lresponse$states)),
                       nrow = length(lresponse$states),
                       byrow = T )
  col_names <- c("icao24", "callsign", "origin_country", "time_position",
                 "time_velocity", "longitude", "latitude", "altitude",
                 "on_ground", "velocity", "heading", "vertical_rate")
  df_response <- as.data.frame(m_response, stringsAsFactors = FALSE)
  colnames(df_response) <- col_names
  df_response[] <- lapply(df_response, type.convert)
  df_response <- df_response[,1:12]
  # Filter data if necessary ---------------------------
  if (isTRUE(complete)){
    vector_sel <- complete.cases(df_response[, by])
    df_response <- df_response[vector_sel, ]
  }

  return(df_response)

}
