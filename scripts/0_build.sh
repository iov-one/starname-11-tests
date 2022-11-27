#!/bin/bash
# set -o pipefail

GIT_SSH_STARNAME10="https://github.com/iov-one/starnamed.git"
GIT_PULL_TAG_STARNAME10="v0.10.13"

GIT_SSH_STARNAME11="https://github.com/iov-one/starname11.git"

DIR_CURRENT_FOLDER=$(pwd)
DIR_TEMP_BUILD="$DIR_CURRENT_FOLDER/tmp/sources"
DIR_BUILDS="$DIR_CURRENT_FOLDER/builds"
DIR_TEMP_BUILD_STARNAME10="$DIR_TEMP_BUILD/starname10"
DIR_TEMP_BUILD_STARNAME11="$DIR_TEMP_BUILD/starname11"

BUILD_TARGET_STARNAME10="$DIR_BUILDS/starnamed10"
BUILD_TARGET_STARNAME11="$DIR_BUILDS/starnamed11"


# GIT Checkout and setup

mkdir -p $DIR_TEMP_BUILD

git clone $GIT_SSH_STARNAME10 $DIR_TEMP_BUILD_STARNAME10
git clone $GIT_SSH_STARNAME11 $DIR_TEMP_BUILD_STARNAME11


# build the starname v10

cd $DIR_TEMP_BUILD_STARNAME10
git checkout "tags/$GIT_PULL_TAG_STARNAME10" -b  "$GIT_PULL_TAG_STARNAME10"
go mod tidy
go mod vendor
make build
cd $DIR_CURRENT_FOLDER


# build the starname v11

cd $DIR_TEMP_BUILD_STARNAME11
go mod tidy
go mod vendor
make build
cd $DIR_CURRENT_FOLDER

# export the builds

mkdir -p $DIR_BUILDS

cp $DIR_TEMP_BUILD_STARNAME10/build/starnamed $BUILD_TARGET_STARNAME10
cp $DIR_TEMP_BUILD_STARNAME11/build/starnamed $BUILD_TARGET_STARNAME11


# Log the versions
eval "$BUILD_TARGET_STARNAME10 version"
eval "$BUILD_TARGET_STARNAME11 version"

