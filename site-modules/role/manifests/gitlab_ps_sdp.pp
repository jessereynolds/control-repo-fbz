# GitLab Server
class role::gitlab_ps_sdp {
  include profile::postfix
  include profile::gitlab
}
