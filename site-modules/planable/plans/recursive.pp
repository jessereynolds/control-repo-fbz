plan planable::recursive (
  Integer $level = 1,
  Integer $max_level = 3,
) {
  $next_level = $level + 1
  out::message("called with level: ${level}, max_level: ${max_level}")
  unless $next_level > $max_level {
    return run_plan('planable::recursive', {
      'level'     => $next_level,
      'max_level' => $max_level,
    })
  }
  return 'foo'
}
