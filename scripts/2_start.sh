#!/bin/bash


VOLUME="$(pwd)/tmp/base_chain"
PASSWORD="12341234"
USER="validator"
CHAIN_ID="testing"
MONIKER="docker_node"

DIR_CURRENT_FOLDER=$(pwd)
DIR_TEMP_BUILD="$DIR_CURRENT_FOLDER/tmp/sources"
DIR_BUILDS="$DIR_CURRENT_FOLDER/builds"
DIR_TEMP_BUILD_STARNAME10="$DIR_TEMP_BUILD/starname10"
DIR_TEMP_BUILD_STARNAME11="$DIR_TEMP_BUILD/starname11"

BUILD_TARGET_STARNAME10="$DIR_BUILDS/starnamed10"
BUILD_TARGET_STARNAME11="$DIR_BUILDS/starnamed11"


export DAEMON_HOME=$VOLUME
export DAEMON_NAME=starnamed

# start the node
cosmovisor run start --home $DAEMON_HOME
