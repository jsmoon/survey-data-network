#!/bin/bash

: ${DPDK_VERSION:=dpdk}

cmd=${1:-dpdk}
shift
if [ "${cmd}" == "list" ]; then
    (cd $HOME/src/${DPDK_VERSION}/examples; ls)
    exit 0
fi

set -x

cd $HOME/src/${DPDK_VERSION} &&
case "${cmd}" in
list)
    set +x && [ -d examples ] && cd examples && ls;;
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
