#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodejs

npm install netlify-cli

echo "Deploying results to Netlify"
./node_modules/.bin/netlify deploy \
  --auth $NETLIFY_AUTH_TOKEN \
  --site $NETLIFY_SITE_ID \
  --dir $(realpath ./result) \
  --message "This was triggered by https://github.com/NixOS/nixos-homepage/commit/$(TRAVIS_COMMIT) commit." \
  --prod
