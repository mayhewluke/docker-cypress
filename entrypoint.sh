#!/bin/bash
HOST_IP=$(route -n | awk '/UG[ \t]/{print $2}')
export CYPRESS_baseUrl="http://$HOST_IP:$CYPRESS_PORT"
yarn "$@"
