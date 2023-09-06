#!/bin/bash

set -xe

ver=$1
docker build . --build-arg "GO_VERSION=$ver" --tag yanhao/golang-dev:$ver
