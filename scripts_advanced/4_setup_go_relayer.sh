#!/bin/bash

DIR_CURRENT_FOLDER=$(pwd)
VOLUME="$DIR_CURRENT_FOLDER/tmp/relayer_go"

./builds/rly config init --home $VOLUME

