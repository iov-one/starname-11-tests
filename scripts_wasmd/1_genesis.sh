#!/bin/bash


VOLUME="$(pwd)/tmp/base_chain"
PASSWORD="12341234"
USER="validator"
CHAIN_ID="testing"
MONIKER="docker_node"
COIN="stake"

DOCKER_NAME="cosmos42"
DOCKER_IMAGE="cosmos:42.5"
DOCKER_MOUNT="/cosmos_chain"

# Create a folder
mkdir -p $VOLUME
rm -fr $VOLUME/config/gentx


# Create a folder
mkdir -p $VOLUME
./builds/wasmd version

# Init the chain
./builds/wasmd --home $VOLUME init --chain-id $CHAIN_ID $MONIKER  -o

cat <<< $(jq '.app_state.gov.voting_params.voting_period = "20s"' $VOLUME/config/genesis.json) > $VOLUME/config/genesis.json
cat <<< $(jq ".app_state.configuration.fees.fee_coin_denom = \"$COIN\"" $VOLUME/config/genesis.json) > $VOLUME/config/genesis.json


# generate validator
(echo $PASSWORD; echo $PASSWORD; echo $PASSWORD) | ./builds/wasmd --home $VOLUME  keys --keyring-backend file add $USER
(echo $PASSWORD) | ./builds/wasmd --home $VOLUME keys --keyring-backend file list

USER_ADDRESS="$(echo 12341234 | ./builds/wasmd --home $VOLUME keys list --keyring-backend file --output json | jq ".[0].address")"
echo "add: $USER_ADDRESS"
#cat <<< $(jq ".app_state.configuration.config.configurer = \"$USER_ADDRESS\"" $VOLUME/config/genesis.json) > $VOLUME/config/genesis.json


# commands
(echo $PASSWORD) | ./builds/wasmd --home $VOLUME add-genesis-account $USER 1000000000000stake --keyring-backend file
(echo $PASSWORD) | ./builds/wasmd --home $VOLUME gentx $USER 10000000000stake --keyring-backend file --chain-id $CHAIN_ID
./builds/wasmd --home $VOLUME collect-gentxs

