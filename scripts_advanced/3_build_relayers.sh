#!/bin/bash

DIR_CURRENT_FOLDER=$(pwd)
DIR_TEMP_BUILD="$DIR_CURRENT_FOLDER/tmp/sources"
DIR_BUILD_RELAYER="$DIR_TEMP_BUILD/relayer"
DIR_BUILD_TS_RELAYER="$DIR_TEMP_BUILD/ts_relayer"
DIR_BUILD_HERMES="$DIR_TEMP_BUILD/hermes"


DOCKER_RELAYER="relayer-go:local"
DOCKER_TS_RELAYER="ts-relayer:local"
DOCKER_HERMES="hermes:local"

# download and build relayers

git clone git@github.com:cosmos/relayer.git $DIR_BUILD_RELAYER
cd $DIR_BUILD_RELAYER && git checkout v2.0.0-rc3
make build
cp ./build/rly $DIR_CURRENT_FOLDER/builds/rly