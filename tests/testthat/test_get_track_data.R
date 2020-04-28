context("Get flights data")

# Read your personal data from a text (comment when upload)
# path_to_file <- paste0(getwd(),"/personal_data.txt")
# username <- read.table(file=path_to_file)[1,]
# password <- read.table(file=path_to_file)[2,]



test_that("get_flights_data works",{
  expect_error(get_flights_data())
  skip('Authentication with personal data in API')
  expect_error(get_flights_data(username=username,password=password))
  expect_error(get_flights_data(username=username,password=password,icao24="3c675a"))
  expect_is(get_flights_data(username=username,password=password,icao24="3c675a",begin=1517184000,end=1517270400),"data.frame")
  expect_is(get_flights_data(username=username,password=password,begin=1517227200,end=1517230800),"data.frame")
})
