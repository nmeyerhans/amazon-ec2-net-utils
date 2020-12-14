#!/bin/bash

# Test a secondary interface (i.e. not eth0) with a multiple IPv4 and
# v6 addresses configured.

INTERFACE=eth2
HWADDR=00:00:5e:00:53:02
ETCDIR=./test-output/etc
_TEST_IPV6_ADDRS=(fd01:ffff:eeee:5:4:3:2:1 fd01:ffff:eeee:5:4:3:2:2)

. ../ec2net-functions
. ./test-functions

# Specific IMDS responses for this test instance
get_meta() {
    echo "CALLED $FUNCNAME" $@ >&2
    case "$1" in
	subnet-ipv4-cidr-block)
	    echo "192.168.10.0/24"
	    ;;
	local-ipv4s)
	    echo "192.168.10.21"
	    echo "192.168.10.22"
	    ;;
	*)
	    echo "unsupported request $1" >&2
	    ;;
    esac
}
