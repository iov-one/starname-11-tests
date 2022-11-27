#!/bin/bash
# set -o pipefail

GIT_SSH_OSMOSIS="git@github.com:osmosis-labs/osmosis.git"
GIT_PULL_TAG_OSMOSIS="v11.0.1"

DIR_CURRENT_FOLDER=$(pwd)
DIR_TEMP_BUILD="$DIR_CURRENT_FOLDER/tmp/sources"
DIR_BUILDS="$DIR_CURRENT_FOLDER/builds"
DIR_TEMP_BUILD_OSMOSIS="$DIR_TEMP_BUILD/osmosis"
BUILD_TARGET_OSMOSIS="$DIR_BUILDS/osmosisd"


# GIT Checkout and setup

mkdir -p $DIR_TEMP_BUILD


git clone $GIT_SSH_OSMOSIS $DIR_TEMP_BUILD_OSMOSIS
cd $DIR_TEMP_BUILD_OSMOSIS
git checkout v11.0.1
make build
cd $DIR_CURRENT_FOLDER

cp $DIR_TEMP_BUILD_OSMOSIS/build/osmosisd $BUILD_TARGET_OSMOSIS

