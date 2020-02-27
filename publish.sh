#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodejs

npm install netlify-cli

echo "Deploying website to Netlify"
./node_modules/.bin/netlify deploy --json --auth $NETLIFY_AUTH_TOKEN --site $NETLIFY_SITE_ID --dir ./result/ --prod
#RESULT=$(./node_modules/.bin/netlify deploy --json --auth $NETLIFY_AUTH_TOKEN --site $NETLIFY_SITE_ID --dir ./result/ --prod | tee /dev/tty)

