#!/bin/sh
CMD=$1
BACKEND_DOMAIN=$2

usage() {
cat <<USAGE
Usage: $0 [CMD] [BACKEND_DOMAIN]
  CMD           : build | build-before | build-after
  BACKEND_DOMAIN: example.com
USAGE
}

build() {
  cd soapbox && yarn && yarn build
  rm -r ../build/$BACKEND_DOMAIN
  mkdir ../build/$BACKEND_DOMAIN
  mv ./static/* ../build/$BACKEND_DOMAIN/
}

build-before() {
  echo "create .env"  
  echo "NODE_ENV=production" > soapbox/.env
  echo "BACKEND_URL=https://$BACKEND_DOMAIN" >> soapbox/.env
  echo "PROXY_HTTPS_INSECURE=true" >> soapbox/.env
}

build-after() {
  rm .env
}

if [ -z "$CMD" ]; then
  usage
  exit 1
fi
case $CMD in
  build)
    build-before
    build
    build-after
    ;;
  build-before)
    build-before
    ;;
  build-after)
    build-after
    ;;
  *)
    usage
    exit 1
    ;;
esac