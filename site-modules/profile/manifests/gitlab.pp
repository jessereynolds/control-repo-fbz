# GitLab Server
class profile::gitlab (
  String $external_url = 'http://127.0.0.1/',
) {
  class { 'gitlab':
    external_url => $external_url,
  }
}

