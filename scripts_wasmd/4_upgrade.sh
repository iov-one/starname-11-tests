#!/bin/bash


VOLUME="$(pwd)/tmp/base_chain"
PASSWORD="12341234"
USER="validator"
CHAIN_ID="testing"
MONIKER="docker_node"

DOCKER_NAME="cosmos42"
DOCKER_IMAGE="cosmos:42.5"
DOCKER_MOUNT="/cosmos_chain"

PROPOSAL_ID="2"

# Made proposal
./builds/starnamed version
./builds/starnamed --home $VOLUME start --minimum-gas-prices=0.001stake

# ./builds/starnamed11-rc2 --home $VOLUME export