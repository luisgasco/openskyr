#' Generate density maps from flight data
#'
#' Allow to generate density maps from flight data in differents output types
#'
#' @param flight_data Dataframe with data from flights.
#' @param crs A character string of projection arguments
#' @param to only works with "raster" string value. Export data in raster format
#' @param min_value Every value under this parameter has not be showed in raster output.
#' Only works when from="points"
#' @param from A character strint to select the density calculation font. It
#' could be "lines" or "points"
#' @return a density map in different type formats.Right now it is only developed "raster" option.
#' @examples
#' raster<-gen_density_map(flight_data, min_value=0, from="points")
#' raster<-gen_density_map(flight_data, from="lines")
#' @export

gen_density_map <- function(flight_data, crs = "+init=epsg:4326", to = "raster",
                            min_value = 0, from = "lines"){
  if (to == "raster"){
    if (from == "points"){
      pattern <- spatstat::ppp(flight_data$longitude, flight_data$latitude,
                     c(min(flight_data$longitude), max(flight_data$longitude)),
                     c(min(flight_data$latitude), max(flight_data$latitude)))
      pix_pattern <- spatstat::pixellate.ppp(pattern, padzero = TRUE,
                                   preserve = TRUE, fractional = TRUE)

      r <- raster::raster(pix_pattern, crs = CRS(crs))
      values(r)[values(r) <= min_value] <- NA
      r <- sp::disaggregate(r, 5)
      r <- raster::focal(r, w = matrix(1, 5, 5), mean)

    }else if (from == "lines"){
      flight_data$icao24 <- as.character(flight_data$icao24)
      v_lines <- trans_pl(data = flight_data, long = "longitude",
                          lat = "latitude",
                          id = "icao24")
      v_lines_spat <- spatstat::as.psp(v_lines)
      pix_pattern <- density(v_lines_spat, 0.01, edge = TRUE,  method = "FFT")
      r <- raster::raster(pix_pattern, crs = CRS(crs))
      r <- sp::disaggregate(r, 5)
      r <- raster::focal(r, w = matrix(1, 5, 5), mean)
    }

    return(r)
  }
}
