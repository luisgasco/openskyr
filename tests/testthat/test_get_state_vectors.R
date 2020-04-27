context("Get state vectors")

# Read your personal data from a text
path_to_file <- paste0(getwd(),"/personal_data.txt")
username = read.table(file=path_to_file)[1,]
password = read.table(file=path_to_file)[2,]



test_that("Get_state_vectors works",{
  expect_error(get_state_vectors(username="test_user",password="noexiste"))
  expect_is(get_state_vectors(username=username,password=password),"data.frame")
  expect_is(get_state_vectors(),"data.frame")
})
