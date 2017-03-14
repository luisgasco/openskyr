#' Transform point trajectories to lines
#'
#' Allow to transform a point data dataframe of flight path to SpatialLines data
#'
#' @param data Dataframe with data from flights.
#' @param long A character string of longitude parameter
#' @param lat A character string of latitude parameter
#' @param id A character string of id of plane, icao24.
#' @return SpatialLines object of line trajectories followed by flights
#' @examples
#' traj <- trans_pl(data = points_df,
#'                    long = "longitude",
#'                    lat = "latitude",
#'                    id="icao24")
#' @export


trans_pl <- function(data, long, lat, id = NULL) {
  # Convert to SpatialPointsDataFrame
  coordinates(data) <- c(long, lat)
  # Split into a list by ID field
  paths <- sp::split(data, data[[id]])

  sp_lines <- sp::SpatialLines(list(Lines(list(Line(paths[[1]])), "line1")))
  for (p in 2:length(paths)) {
    id <- paste0("line", as.character(p))
    l <- sp::SpatialLines(list(sp::Lines(list(sp::Line(paths[[p]])), id)))
    sp_lines <- maptools::spRbind(sp_lines, l)
  }

  return(sp_lines)
}
