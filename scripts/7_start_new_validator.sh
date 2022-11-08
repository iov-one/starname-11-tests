#!/bin/bash

VOLUME_1="$(pwd)/tmp/base_chain"
VOLUME_2="$(pwd)/tmp/base_chain_node_2"
PASSWORD="12341234"
USER="validator"
MOCK_USERS="mock_user_1 mock_user_2"
CHAIN_ID="testing"
MONIKER="docker_node_2"
COIN="stake"

DIR_CURRENT_FOLDER=$(pwd)
DIR_TEMP_BUILD="$DIR_CURRENT_FOLDER/tmp/sources"
DIR_BUILDS="$DIR_CURRENT_FOLDER/builds"
DIR_TEMP_BUILD_STARNAME10="$DIR_TEMP_BUILD/starname10"
DIR_TEMP_BUILD_STARNAME11="$DIR_TEMP_BUILD/starname11"

BUILD_TARGET_STARNAME10="$DIR_BUILDS/starnamed10"
BUILD_TARGET_STARNAME11="$DIR_BUILDS/starnamed11"

# Create a folder
mkdir -p $VOLUME_2
export DAEMON_HOME=$VOLUME_2
export DAEMON_NAME=starnamed

# start the node
cosmovisor run start --home $DAEMON_HOME

