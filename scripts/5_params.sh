#!/bin/bash

account_renewal_period='31557600s'
account_renewal_count_max='2'
account_grace_period='2592000s'
certificate_size_max='1024'
certificate_count_max='5'
domain_renewal_period='31557600s'
domain_renewal_count_max='2'
domain_grace_period='2592000s'
metadata_size_max='1024'
resources_max='24'
valid_domain_name='^[mabcdefghijklnopqrstuvwxyz0123456789][-a-z0-9_]{0,2}$|^[-a-z0-9_]{4,32}'
valid_account_name='^[-.a-z0-9_]{1,63}$'
valid_uri='^[-a-z0-9]{1,15}:[-a-z0-9]{1,40}$'
valid_resource='^[-.a-z0-9A-Z/:_\s#]{1,200}$'

CONFIGURER=$(./builds/starnamed11 --home ./tmp/base_chain q configuration get-config | jq ".configuration.configurer")

(echo '12341234') | ./builds/starnamed11  --home ./tmp/base_chain tx configuration update-config --from mock_user_1 --keyring-backend file --yes --chain-id testing \
    --account-renew-period $account_renewal_period --account-renew-count-max $account_renewal_count_max --account-grace-period $account_grace_period \
    --certificate-size-max $certificate_size_max --certificate-count-max $certificate_count_max \
    --domain-renew-period $domain_renewal_period --domain-renew-count-max $domain_renewal_count_max --domain-grace-period $domain_grace_period \
    --metadata-size-max $metadata_size_max \
    --resource-max $resources_max \
    --valid-domain-name $valid_domain_name --valid-account-name $valid_account_name --valid-uri $valid_uri --valid-resource $valid_resource