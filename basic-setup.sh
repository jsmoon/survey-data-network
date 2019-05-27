#!/bin/bash
set -x
sudo apt-get upgrade && sudo apt-get update || exit $?

# to connect by ssh from host
sudo apt-get install openssh-server -y || exit $?

# ready to build from sources
sudo apt-get install build-essential dkms -y || exit $?

