#!/bin/sh
BACKEND_URL=$1

usage() {
cat <<USAGE
Usage: $0 [BACKEND_URL]
USAGE
}

build() {
  echo "create .env"  
  echo "NODE_ENV=production" > soapbox/.env
  echo "BACKEND_URL=$BACKEND_URL" >> soapbox/.env
  echo "PROXY_HTTPS_INSECURE=true" >> soapbox/.env
  cd soapbox && yarn install && yarn build && mv ./static/* ../$BACKEND_URL/
  rm .env
}

if [ -z "$BACKEND_URL" ]; then
  usage
  exit 1
else
  build
fi