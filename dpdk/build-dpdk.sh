#!/bin/bash

: ${DPDK_VERSION:=dpdk}

PROG=$(basename $0)
USAGE="$PROG - build dpdk and examples after setup-src.sh

[DPDK_VERSION=dpdk[-stable]] $PROG <sub-commands> [<options>]

sub-commands:
help		display this message
list		list all DPDK examples

dpdk		build DPDK library
dpdk-debug	build DPDK library with debug messages
examples	build all DPDK examples
<exmaple>	build specified one of examples
"

cmd=${1:-help}
shift
if [ "${cmd}" == "help" ]; then
    echo "$USAGE"
    exit 0
fi
if [ "${cmd}" == "list" ]; then
    (cd $HOME/src/${DPDK_VERSION}/examples && ls -d */)
    exit 0
fi

set -x

cd $HOME/src/${DPDK_VERSION} &&
case "${cmd}" in
dpdk)
    make $@;;
dpdk-debug)
    make DEBUG=1 $@;;
examples)
    # examples/l2fwd --> build/examples/l2fwd/build/app/
    make -C examples RTE_SDK=$(pwd) RTE_TARGET=build O=$(pwd)/build/examples $@;;
*)
    [ -d examples/$cmd ] &&
        make -C examples/$cmd RTE_SDK=$(pwd) RTE_TARGET=build O=$(pwd)/build/examples/$cmd/build $@ &&
        set +x &&
        { [ ! -d $(pwd)/build/examples/$cmd/build ] || ls -l $(pwd)/build/examples/$cmd/build/app/; } ;;
esac

exit $?

# more information
./build-dpdk.sh dpdk-debug V=1
