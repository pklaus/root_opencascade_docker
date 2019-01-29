#!/bin/bash

JOBS=14
OCC_VERSION=7.0.0
OCC_VERSION=7.1.0
OCC_VERSION=7.2.0
OCC_VERSION=6.9.1
ROOT_VERSION=6.12.06

docker build \
  -t pklaus/root:v${ROOT_VERSION}_${OCC_VERSION} \
  --build-arg JOBS=$JOBS \
  --build-arg OCC_VERSION=$OCC_VERSION \
  --build-arg ROOT_VERSION=$ROOT_VERSION \
  --squash \
  .
