#!/bin/bash

BASEDIR=$(readlink -f "$(dirname $0)")

if [ -z "$1"  ]; then
    echo "Usage: ./connect_openvpn.sh <client-config>"
    exit 1
fi
OPENVPN_CONFIG=$1

CHECK_PROCESS_EXISTS=`pgrep -f "openvpn --daemon --config ${OPENVPN_CONFIG}"`

if [ -n "${CHECK_PROCESS_EXISTS}" ]; then
    echo "OpenVPN Script already running!"
    exit 0
fi

sudo openvpn --daemon --config $OPENVPN_CONFIG

echo "Connected OpenVPN!"

