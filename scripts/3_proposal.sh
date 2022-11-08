#!/bin/bash


VOLUME="$(pwd)/tmp/base_chain"
PASSWORD="12341234"
USER="validator"
CHAIN_ID="testing"
MONIKER="docker_node"

DOCKER_NAME="cosmos42"
DOCKER_IMAGE="cosmos:42.5"
DOCKER_MOUNT="/cosmos_chain"

PROPOSAL_ID="1"

# Made proposal
./builds/starnamed10 version
(echo "12341234") | ./builds/starnamed10 --home $VOLUME tx gov  submit-proposal software-upgrade cosmos-sdk-v0.44-upgrade --upgrade-height 20  --keyring-backend file --from validator --title v44 --description v044 --chain-id testing --yes

(echo "12341234") | ./builds/starnamed10 --home $VOLUME tx gov  deposit $PROPOSAL_ID 10000000ustake --keyring-backend file --from validator --chain-id testing --yes

(echo "12341234") | ./builds/starnamed10 --home $VOLUME tx gov  vote $PROPOSAL_ID yes  --keyring-backend file --from validator --chain-id testing --yes

./builds/starnamed10 --home $VOLUME q gov tally $PROPOSAL_ID