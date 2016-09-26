#!/bin/bash

BASEDIR=$(readlink -f "$(dirname $0)")

cd "${BASEDIR}"

sudo openvpn --daemon --config client.ovpn

