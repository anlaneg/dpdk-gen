#! /bin/bash
#require gcc numactl-devel libnuma-dev
#version=16.11
dir="dpdk$version"
export RTE_TARGET=x86_64-native-linuxapp-gcc
export RTE_SDK=`pwd`/$dir
if [ ! -e $dir -o 1 ] ; 
then
	git clone https://github.com/anlaneg/dpdk.git $dir
	(cd $dir ; make config; cd $RTE_SDK; make install T=$RTE_TARGET DESTDIR=build/x86_64 -j8 )
fi;
make 

