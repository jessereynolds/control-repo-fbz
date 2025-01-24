plan planable::failure (
) {
  $result = run_task('planable::error', get_targets(['localhost', 'localhost6']), {
    'level' => 1,
    '_catch_errors' => true
  })
  # return $result
  fail_plan('I am sorry I screwed up', 'planable/error')
}
