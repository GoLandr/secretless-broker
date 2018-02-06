#!/bin/bash -ex

source ./_conjur.sh

admin_api_key=$(docker-compose exec conjur conjurctl role retrieve-key dev:user:admin | tr -d '\r')
myapp_tls_api_key=$(conjur_cli "$admin_api_key" host rotate_api_key -h myapp_tls | tr -d '\r')

export CONJUR_AUTHN_API_KEY="$myapp_tls_api_key"

docker-compose up --no-deps -d myapp_tls

docker-compose run --rm -v $PWD/../src/proxy_tls/proxy_tls.pem:/proxy_tls.pem client curl --cacert /proxy_tls.pem https://myapp_tls
