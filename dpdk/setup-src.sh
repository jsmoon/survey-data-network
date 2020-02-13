#!/bin/bash

PROG=$(basename $0)
USAGE="$PROG -- setup DPDK source before build

$PROG {install|update}[-config]
"

cmd=${1:-help}
if [ "${cmd}" == "help" ]; then
    echo "$USAGE"
    exit 0
fi

set -x

cd $HOME/src

# install required packages for build
if [ "${cmd}" == "install" ]; then
    sudo apt-get install libpcap-dev -y &&
    sudo apt-get install libfdt-dev -y &&
    sudo apt install pkg-config

    # clone major version
    [ -d dpdk ] || git clone git://dpdk.org/dpdk
    # clone stable version
    [ -d dpdk-stable ] || git clone git://dpdk.org/dpdk-stable
fi

if [ "${cmd}" == "update" ]; then
    [ -d dpdk ] && (cd dpdk && git pull)
    [ -d dpdk-stable ] && (cd dpdk-stable && git pull)
fi

# setup build config
if [ "${cmd#*-}" == "config" ]; then
for src in dpdk dpdk-stable; do
    cd $HOME/src/$src

    make config T=x86_64-native-linuxapp-gcc
    # enable pcap: libpcap headers are required
    sed -ri 's,(PMD_PCAP=).*,\1y,' build/.config

    # disable NUMA config due to numa.h and numaif.h are missing.
    sed -ri 's,(RTE_EAL_NUMA_AWARE_HUGEPAGES=).*,\1n,' build/.config
    sed -ri 's,(RTE_LIBRTE_VHOST_NUMA=).*,\1n,' build/.config

    # disable IFPGA config due to build failure.
    sed -ri 's,(RTE_LIBRTE_IFPGA_BUS=).*,\1n,' build/.config
    sed -ri 's,(RTE_LIBRTE_PMD_IFPGA_RAWDEV=).*,\1n,' build/.config
done
fi
