plan planable::wait_on_task_2 (
  TargetSpec $targets,
  Integer    $seconds = 60,
) {
  run_task("planable::sleep", get_targets($targets), {'seconds' => $seconds,})
}
