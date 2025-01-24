plan planable::handle_errors {
  $result_or_error = run_plan('planable::failure', {
    '_catch_errors' => true,
  })
  # $result_or_error = run_plan('planable::recursive', {
  #   'max_level'     => 2,
  #   '_catch_errors' => true,
  # })
  $result = case $result_or_error {
    # When the plan returned a ResultSet use it.
    ResultSet: {
      out::message('got ResultSet')
      $result_or_error
    }
    # When the plan returned a PlanResult (superset of ResultSet) use it.
    PlanResult: {
      out::message('got a PlanResult of some description')
      $result_or_error
    }
    # If the run_task failed extract the result set from the error.
    Error['bolt/run-failure']: {
      out::message('got Error[bolt/run-failure]')
      $result_or_error.details['result_set']
    }
    # The sub-plan failed for an unexpected reason.
    default: {
      out::message('in the default')
      fail_plan($result_or_error)
    }
  }
  return $result
  # Run a task on the successful targets
  # run_task('mymodule::task', $result.ok_set)
}
