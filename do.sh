#! /bin/bash
#require gcc numactl-devel libnuma-dev
export RTE_SDK
export RTE_TARGET=x86_64-native-linuxapp-gcc

function clean()
{
	make clean
}
function build()
{
	make V=1
}

function run()
{
	sysctl vm.nr_hugepages=64
	export PCI_LIST=`lspci | grep "Eth" | grep "Virtio network device"| cut -d' ' -f 1 | tr  '\n' ' '`
	./tools/setup.sh
	#dpdk_opts="-l 8,9-16 -n 4 --proc-type auto --log-level 7 --socket-mem 2048,2048 --file-prefix pg"
	dpdk_opts="-l 1 -n 4 --proc-type auto --log-level 7 --socket-mem 64 --file-prefix pg"
	pktgen_opts="-T -P --crc-strip"
	#pktgen_opts="${pktgen_opts} -m [2:3].8 -m [18:19].9"
	#core 1 handles port 0 rx/tx and core 1 handles port 1 rx/tx
	pktgen_opts="${pktgen_opts} -m 1.0 -m 1.1"
	#./tools/run.sh
	load_file="-f themes/black-yellow.theme" #-f test/tx-rx-loopback.lua

	ulimit -c unlimited
	cmd=./app/${RTE_TARGET}/pktgen
	echo ${cmd} ${dpdk_opts} ${black_list} -- ${pktgen_opts} ${load_file}
	sudo ${cmd} ${dpdk_opts} ${black_list} -- ${pktgen_opts} ${load_file}

	# Restore the screen and keyboard to a sane state
	echo "[1;r"
	echo "[99;1H"
	stty sane
}

function main()
{
	if [ "X$1" == "Xclean" ];
	then
		clean
	elif [ "X$1" == "Xrun" ];
	then
		run
	else
		build	
	fi;
}

main $1
