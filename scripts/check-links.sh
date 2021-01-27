#! /usr/bin/env bash

export PORT=8137

serve &
server_pid=$!
linkchecker http://localhost:$PORT --ignore-url /nixpkgs/
status=$?
kill $server_pid
exit $status
