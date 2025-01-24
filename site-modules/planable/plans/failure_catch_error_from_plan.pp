plan planable::failure_catch_error_from_plan (
) {
  $result = run_plan('planable::failure', {
    '_catch_errors' => false
  })
  case $result {
    ResultSet: {
      out::message("result is a ResultSet")
    }
    Error: {
      out::message("result is an Error")
    }
    default: {
      out::message("result is something else")
    }
  }
  # assert_type(String, $result)
  out::message("result is a ${type($result)}")
  out::message($result.ok)
  return $result
  # fail_plan('I am sorry I screwed up', 'planable/error')
}
