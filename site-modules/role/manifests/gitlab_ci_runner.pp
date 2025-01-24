# GitLab CI Runner
class role::gitlab_ci_runner {
  include profile::gitlab_ci_runner
  include profile::test_agent
}
