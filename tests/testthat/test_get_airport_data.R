context("Get airport data")

# Read your personal data from a text
path_to_file <- paste0(getwd(),"/personal_data.txt")
username = read.table(file=path_to_file)[1,]
password = read.table(file=path_to_file)[2,]



test_that("get_airport_data works",{
  expect_error(get_airport_data())
  skip('Authentication with personal data in API')
  expect_error(get_airport_data(username=username,password=password,option="trial"))
  expect_error(get_airport_data(username=username,password=password,option="departures")) # Needs more data
  expect_error(get_airport_data(username=username,password=password,option="departures",airport="EDDF")) # Needs more data
  expect_error(get_airport_data(username=username,password=password,option="departures",airport="EDDF",begin=1517227200))
  expect_is(get_airport_data(username=username,password=password,option="departures",airport="EDDF",begin=1517227200,end=1517230800),"data.frame")
  expect_is(get_airport_data(username=username,password=password,option="departures",airport="EDDF",begin=1517227200,end=1517230800),"data.frame")
})
