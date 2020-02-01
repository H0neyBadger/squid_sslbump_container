Squid SSL Bump container
------------------------

Gen key
```
openssl req -new -newkey \
  rsa:2048 -sha256 -days 365 \
  -nodes -x509 -extensions v3_ca \
  -keyout ca.key -out ca.pem
cat ca.key ca.pem > ssl_cert/ca.key
```

Build container image 
```
podman build -t squid .
sudo chcon -Rv -t container_file_t './squid_ssl.conf'  
sudo chcon -Rv -t container_file_t './ssl_cert'
``` 

Run container
```
podman --log-level=debug run --rm -it \
  --volume "$(pwd)/squid.conf:/etc/squid/squid.conf:ro" \
  --volume "$(pwd)/ssl_cert/:/etc/squid/ssl_cert/:ro" \
  --publish 3128:3128 \
  localhost/squid:latest 
```

Update ca trust
```
sudo cp ca.pem /etc/pki/ca-trust/source/anchors/squid_proxy.pem
sudo update-ca-trust
```

Demo
```
export https_proxy=localhost:3128
curl https://github.com/H0neyBadger
```
