#!/bin/bash

ROOT_VERSION=6.12.06

docker build -t pklaus/root:v --build-arg ROOT_VERSION=$ROOT_VERSION --squash .

