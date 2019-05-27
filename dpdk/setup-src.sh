#!/bin/bash
set -x

cd $HOME/src

# install required packages for build
sudo apt-get install libpcap-dev -y &&
sudo apt install pkg-config

# clone major version
[ -d dpdk ] || git clone git://dpdk.org/dpdk
# clone stable version
[ -d dpdk-stable ] || git clone git://dpdk.org/dpdk-stable

# setup build config
for src in dpdk dpdk-stable; do
    cd $HOME/src/$src

    make config T=x86_64-native-linuxapp-gcc
    # enable pcap: libpcap headers are required
    sed -ri 's,(PMD_PCAP=).*,\1y,' build/.config

    # disable NUMA config due to numa.h and numaif.h are missing.
    sed -ri 's,(RTE_EAL_NUMA_AWARE_HUGEPAGES=).*,\1n,' build/.config
    sed -ri 's,(RTE_LIBRTE_VHOST_NUMA=).*,\1n,' build/.config
done
