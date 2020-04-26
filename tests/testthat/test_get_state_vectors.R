context("Get state vectors")

test_that("Get_state_vectors works",{
  expect_error(get_state_vectors(username="luisgasco",password="noexiste"))
})
