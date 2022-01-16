#!/usr/bin/env bash

set -euo pipefail

if (( $# != 1 )); then
	echo "Usage: $0 <path to local checkout>"
	exit 1
fi

local_checkout="$1"; shift

echo " :: Setting up development environment to use a local NixOS common styles checkout."

if [ -e site-styles/common-styles ]; then
	echo -n "Removing possibly stale symlink: "
	rm -vf site-styles/common-styles
fi

echo -n "Linking with local checkout: "
ln -vs "$(readlink -f "$local_checkout/src")" site-styles/common-styles
