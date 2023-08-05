#!/usr/bin/env bash

FORCE_ROOT_CA_GENERATION=false
DOMAIN=localhost

if [[ $FORCE_ROOT_CA_GENERATION == true || ! -f "ca/rootCA.crt" ]]; then
  rm -rf ca
  mkdir -p ca

  keychain_path=$(security login-keychain | tr -d '[:space:]\"')
  # Remove trusted certificate if exists
  security delete-certificate -c disco.toma2.ca -t "$keychain_path"

  # Create root CA & Private key
  openssl req -x509 \
              -sha256 -days 356 \
              -nodes \
              -newkey rsa:2048 \
              -subj "/CN=disco.toma2.ca/C=IN/ST=West Bengal/L=Kolkata/O=Disco Toma2/OU=DT2 Certificate Authority" \
              -keyout ca/rootCA.key -out ca/rootCA.crt

  # Add trusted certificate to mac keychain
  security add-trusted-cert -d -k "$keychain_path" ca/rootCA.crt
else
  echo -e "\033[0;31mSkipping root CA generation\033[0m"
fi

# Generate Private key
openssl genrsa -out ${DOMAIN}.key 2048

# Create csf conf
cat > csr.conf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = IN
ST = West Bengal
L = Kolkata
O = Disco Toma2
OU = DT2 App
CN = ${DOMAIN}

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = *.ap-south-1.amazonaws.com
DNS.2 = *.joe.in

EOF

# create CSR request using private key
openssl req -new -key ${DOMAIN}.key -out ${DOMAIN}.csr -config csr.conf

# Create a external config file for the certificate
cat > cert.conf <<EOF

authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.ap-south-1.amazonaws.com
DNS.2 = *.joe.in

EOF

# Create SSl with self signed CA
openssl x509 -req \
    -in ${DOMAIN}.csr \
    -CA ca/rootCA.crt -CAkey ca/rootCA.key \
    -CAcreateserial -out ${DOMAIN}.crt \
    -days 365 \
    -sha256 -extfile cert.conf

rm csr.conf
rm cert.conf
rm localhost.csr
rm ca/rootCA.srl
