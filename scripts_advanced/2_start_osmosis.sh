#!/bin/bash


VOLUME="$(pwd)/tmp/osmosis_chain"
PASSWORD="12341234"
USER="validator"
CHAIN_ID="testing"
MONIKER="docker_node"

./builds/osmosisd --home $VOLUME start