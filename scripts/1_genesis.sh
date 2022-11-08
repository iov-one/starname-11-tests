#!/bin/bash


VOLUME="$(pwd)/tmp/base_chain"
PASSWORD="12341234"
USER="validator"
MOCK_USERS="mock_user_1 mock_user_2"
CHAIN_ID="testing"
MONIKER="docker_node"
COIN="ustake"

DOCKER_NAME="cosmos42"
DOCKER_IMAGE="cosmos:42.5"
DOCKER_MOUNT="/cosmos_chain"

# Create a folder
mkdir -p $VOLUME
rm -fr $VOLUME/config/gentx


# Create a folder
mkdir -p $VOLUME
./builds/starnamed10 version

# Init the chain
./builds/starnamed10 --home $VOLUME init --chain-id $CHAIN_ID $MONIKER  -o

sed -i "s/\"stake\"/\"$COIN\"/g" $VOLUME/config/genesis.json
cat <<< $(jq '.app_state.gov.voting_params.voting_period = "20s"' $VOLUME/config/genesis.json) > $VOLUME/config/genesis.json
cat <<< $(jq ".app_state.configuration.fees.fee_coin_denom = \"$COIN\"" $VOLUME/config/genesis.json) > $VOLUME/config/genesis.json


# generate validator
(echo $PASSWORD; echo $PASSWORD; echo $PASSWORD) | ./builds/starnamed10 --home $VOLUME  keys --keyring-backend file add $USER --output json 2>&1 | jq > mnemonic_validator.json

# generate users

for usr in $MOCK_USERS; do 
    (echo $PASSWORD; echo $PASSWORD) | ./builds/starnamed10 --home $VOLUME  keys --keyring-backend file add $usr --output json 2>&1 | jq > mnemonic_$usr.json
done

(echo $PASSWORD) | ./builds/starnamed10 --home $VOLUME keys --keyring-backend file list
USER_ADDRESS="$(echo 12341234 | ./builds/starnamed10 --home $VOLUME keys list --keyring-backend file --output json | jq ".[0].address")"
echo "add: $USER_ADDRESS"
cat <<< $(jq ".app_state.configuration.config.configurer = $USER_ADDRESS" $VOLUME/config/genesis.json) > $VOLUME/config/genesis.json

# commands
(echo $PASSWORD) | ./builds/starnamed10 --home $VOLUME add-genesis-account $USER "10000000000000$COIN" --keyring-backend file

for usr in $MOCK_USERS; do 
    (echo $PASSWORD) | ./builds/starnamed10 --home $VOLUME add-genesis-account $usr "10000000000$COIN" --keyring-backend file
done

(echo $PASSWORD) | ./builds/starnamed10 --home $VOLUME gentx $USER "10000000000$COIN" --keyring-backend file --chain-id $CHAIN_ID
./builds/starnamed10 --home $VOLUME collect-gentxs


# Setup cosmosvisor

DIR_CURRENT_FOLDER=$(pwd)
DIR_TEMP_BUILD="$DIR_CURRENT_FOLDER/tmp/sources"
DIR_BUILDS="$DIR_CURRENT_FOLDER/builds"
DIR_TEMP_BUILD_STARNAME10="$DIR_TEMP_BUILD/starname10"
DIR_TEMP_BUILD_STARNAME11="$DIR_TEMP_BUILD/starname11"

BUILD_TARGET_STARNAME10="$DIR_BUILDS/starnamed10"
BUILD_TARGET_STARNAME11="$DIR_BUILDS/starnamed11"


export DAEMON_HOME=$VOLUME
export DAEMON_NAME=starnamed

# cosmosvisor
mkdir -p $DAEMON_HOME/cosmovisor/genesis/bin
mkdir -p $DAEMON_HOME/cosmovisor/upgrades/cosmos-sdk-v0.44-upgrade/bin
cp $BUILD_TARGET_STARNAME10 $DAEMON_HOME/cosmovisor/genesis/bin/starnamed
cp $BUILD_TARGET_STARNAME11 $DAEMON_HOME/cosmovisor/upgrades/cosmos-sdk-v0.44-upgrade/bin/starnamed
