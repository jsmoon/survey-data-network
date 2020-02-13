#!/bin/bash

cd $HOME/src/trex-core

set -x

# build document
#(cd doc && ./b configure && ./b build) &&
# build bp-sim
(cd linux && ./b configure && ./b build) &&
# build _t-rex
(cd linux_dpdk && ./b configure && ./b build)
