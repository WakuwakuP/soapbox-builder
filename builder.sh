#!/bin/sh
CMD=$1
BACKEND_URL=$2

usage() {
cat <<USAGE
Usage: $0 [CMD] [BACKEND_URL]
  CMD        : build | build-before | build-after
  BACKEND_URL: https://example.com
USAGE
}

build() {
  echo "create .env"  
  echo "NODE_ENV=production" > soapbox/.env
  echo "BACKEND_URL=$BACKEND_URL" >> soapbox/.env
  echo "PROXY_HTTPS_INSECURE=true" >> soapbox/.env
  cd soapbox && yarn && yarn build
  rm -r ../build/$BACKEND_URL
  mkdir ../build/$BACKEND_URL
  mv ./static/* ../build/$BACKEND_URL/
  rm .env
}

build-before() {
  echo "create .env"  
  echo "NODE_ENV=production" > soapbox/.env
  echo "BACKEND_URL=$BACKEND_URL" >> soapbox/.env
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