#!/bin/sh

init=$(vault operator init \
  -format=json \
  -key-shares=3 \
  -key-threshold=2 | jq )

root_token=$(echo $init | jq -r '.root_token')
key1=$(echo $init | jq -r '.unseal_keys_b64[0]')
key2=$(echo $init | jq -r '.unseal_keys_b64[1]')
key3=$(echo $init | jq -r '.unseal_keys_b64[3]')

