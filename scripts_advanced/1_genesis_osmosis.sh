#!/bin/bash


VOLUME="$(pwd)/tmp/osmosis_chain"
PASSWORD="12341234"
USER="validator"
MOCK_USERS="mock_user_1 mock_user_2"
CHAIN_ID="testing-osmosis"
MONIKER="local-osmosis"
COIN="uosmo"

DOCKER_NAME="cosmos42"
DOCKER_IMAGE="cosmos:42.5"
DOCKER_MOUNT="/cosmos_chain"

# Create a folder
mkdir -p $VOLUME
rm -fr $VOLUME/config/gentx


# Create a folder
mkdir -p $VOLUME
./builds/osmosisd version

# Init the chain
./builds/osmosisd --home $VOLUME init --chain-id $CHAIN_ID $MONIKER  -o

sed -i "s/\"stake\"/\"$COIN\"/g" $VOLUME/config/genesis.json
cat <<< $(jq '.app_state.gov.voting_params.voting_period = "20s"' $VOLUME/config/genesis.json) > $VOLUME/config/genesis.json


# generate validator
validator_mnemonic=$(cat mnemonic_$USER.json | jq .mnemonic)
( echo "$validator_mnemonic"; echo $PASSWORD; echo $PASSWORD; echo $PASSWORD) | ./builds/osmosisd --home $VOLUME  keys --keyring-backend file add $USER --output json

# generate users

for usr in $MOCK_USERS; do 
    usr_mnemonic=$(cat mnemonic_$usr.json | jq .mnemonic)
    (echo $validator_mnemonic; echo $PASSWORD; echo $PASSWORD) | ./builds/osmosisd --home $VOLUME  keys --keyring-backend file add $usr --output json
done

(echo $PASSWORD) | ./builds/osmosisd --home $VOLUME keys --keyring-backend file list

# commands
(echo $PASSWORD) | ./builds/osmosisd --home $VOLUME add-genesis-account $USER "10000000000000$COIN" --keyring-backend file

for usr in $MOCK_USERS; do 
    (echo $PASSWORD) | ./builds/osmosisd --home $VOLUME add-genesis-account $usr "10000000000$COIN" --keyring-backend file
done

(echo $PASSWORD) | ./builds/osmosisd --home $VOLUME gentx $USER "10000000000$COIN" --keyring-backend file --chain-id $CHAIN_ID
./builds/osmosisd --home $VOLUME collect-gentxs

