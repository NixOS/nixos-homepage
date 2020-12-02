#! /usr/bin/env bash

LINKCHECK_PORT=8137

caddy -port $LINKCHECK_PORT &
server_pid=$!
linkchecker http://localhost:$LINKCHECK_PORT \
    --ignore-url /nixpkgs/
status=$?
kill $server_pid
exit $status
