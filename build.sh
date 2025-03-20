#!/bin/bash

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Usage: build.sh VERSION"
  exit 1
fi

docker buildx build \
  --platform linux/amd64 \
  --build-arg BUILDPLATFORM=linux/amd64 \
  --build-arg TARGETPLATFORM=linux/amd64 \
  --build-arg VERSION=${VERSION} \
  --tag ghijnuuz/snell-server:$VERSION \
  .

docker tag ghijnuuz/snell-server:$VERSION ghijnuuz/snell-server:latest

docker push ghijnuuz/snell-server:$VERSION
docker push ghijnuuz/snell-server:latest
