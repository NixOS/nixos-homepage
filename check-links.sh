#! /usr/bin/env bash

caddy -port 8080 &
server_pid=$!
linkchecker http://localhost:8080
status=$?
kill $server_pid
exit $status
