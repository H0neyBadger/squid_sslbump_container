#!/bin/bash

set -xeuo pipefail

# openssl req -new -newkey \
#   rsa:2048 -sha256 -days 365 \
#   -nodes -x509 -extensions v3_ca \
#   -keyout ca.key -out ca.pem
# cat ca.key ca.pem > ssl_cert/ca.key

# podman build -t squid .
# sudo chcon -Rv -t container_file_t './squid_ssl.conf'  
# sudo chcon -Rv -t container_file_t './ssl_cert'

podman --log-level=debug run --rm -it \
  --volume "$(pwd)/squid.conf:/etc/squid/squid.conf:ro" \
  --volume "$(pwd)/ssl_cert/:/etc/squid/ssl_cert/:ro" \
  --publish 3128:3128 \
  localhost/squid:latest 
