#! /bin/bash

RTE_SDK=
if [ -e ../anlaneg_dpdk ];
then
	RTE_SDK=`pwd`/../anlaneg_dpdk/
fi;
export RTE_SDK
make V=1
