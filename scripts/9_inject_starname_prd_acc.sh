#!/bin/bash

VOLUME="$(pwd)/tmp/base_chain"

starname_accounts=$(cat prd.v10.genesis.json | jq .app_state.starname.accounts)
starname_domains=$(cat prd.v10.genesis.json | jq .app_state.starname.domains)

cat <<< $(jq ".app_state.starname.accounts = $starname_accounts" $VOLUME/config/genesis.json) > $VOLUME/config/genesis.json
cat <<< $(jq ".app_state.starname.domains = $starname_domains" $VOLUME/config/genesis.json) > $VOLUME/config/genesis.json
