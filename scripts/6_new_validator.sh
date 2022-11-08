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

# cosmosvisor
mkdir -p $DAEMON_HOME/cosmovisor/genesis/bin
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/cosmos-sdk-v0.44-upgrade/bin
cp $BUILD_TARGET_STARNAME10 $DAEMON_HOME/cosmovisor/genesis/bin/starnamed
cp $BUILD_TARGET_STARNAME11 $DAEMON_HOME/cosmovisor/upgrades/cosmos-sdk-v0.44-upgrade/bin/starnamed


# Init the chain
./builds/starnamed10 --home $VOLUME_2 init --chain-id $CHAIN_ID $MONIKER -o

# remove unused files
rm -fr $VOLUME_2/config/gentx
rm -fr $VOLUME_2/config/genesis.json
cp $VOLUME_1/config/genesis.json $VOLUME_2/config/genesis.json

# First node ID
NODE_1_ID="$(./builds/starnamed11  --home $VOLUME_1 tendermint show-node-id)"


# connect to other node
sed -i 's/127.0.0.1:26657/127.0.0.1:36657/g' $VOLUME_2/config/config.toml
sed -i 's/0.0.0.0:26656/0.0.0.0:36656/g' $VOLUME_2/config/config.toml
sed -i "s/persistent_peers = \"\"/persistent_peers = \"$NODE_1_ID@0.0.0.0:26656\"/g" $VOLUME_2/config/config.toml
sed -i "s/enable = true/enable = false/g" $VOLUME_2/config/app.toml

