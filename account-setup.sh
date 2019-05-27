#!/bin/bash
ACCOUNT=${1:?}
set -x

# add user account
sudo useradd -U -G sudo -s /bin/bash -m -k /dev/null $ACCOUNT || exit $?

# make it sudoer
sudo echo "$ACCOUNT ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$ACCOUNT || exit $?

# set first password by manual
sudo passwd $ACCOUNT

