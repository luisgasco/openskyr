context("Get track data")

# Read your personal data from a text
path_to_file <- paste0(getwd(),"/personal_data.txt")
username = read.table(file=path_to_file)[1,]
password = read.table(file=path_to_file)[2,]



test_that("get_track_data works",{
  expect_error(get_track_data())
  skip('Authentication with personal data in API')
  expect_error(get_track_data(username=username,password=password))
  expect_error(get_track_data(username=username,password=password,icao24="494103"))
  expect_error(get_track_data(username=username,password=password,time=1587126600))
  expect_is(get_track_data(username=username,password=password,icao24="494103",time=1587126600),"data.frame")
})

