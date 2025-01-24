#!/bin/bash

sudo puppet apply --hiera_config hiera.yaml --modulepath modules:site-modules  -e 'include role::gitlab_ps_sdp'

