#!/bin/bash

VOLUME_1="$(pwd)/tmp/base_chain"
VOLUME_2="$(pwd)/tmp/base_chain_node_2"
PASSWORD="12341234"
USER="validator"
MOCK_USERS="mock_user_1 mock_user_2"
CHAIN_ID="testing"
MONIKER="docker_node_2"
COIN="ustake"

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

NODE_2_ID=$($BUILD_TARGET_STARNAME11 --home $VOLUME_2 tendermint show-node-id)
NODE_2_VALIDATOR=$($BUILD_TARGET_STARNAME11 --home $VOLUME_2 tendermint show-validator)


# import the mnemonic to the new validator
(echo $PASSWORD) | $BUILD_TARGET_STARNAME11 --home $VOLUME_1 --keyring-backend file tx staking create-validator --yes --from $USER \
    --amount "10000000$COIN" --pubkey $NODE_2_VALIDATOR --node-id $NODE_2_ID \
    --commission-rate 0 --commission-max-rate 0 --commission-max-change-rate 0 \
    --min-self-delegation 10000000 $@ --chain-id $CHAIN_ID