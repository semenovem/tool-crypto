#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/util.sh" ""

for f in $(find "${__CRYPTO_PEER__:?}" -iname "*_sk"); do
  mv "$f" "$(dirname "$f")/key.pem"
done

for f in $(find "${__CRYPTO_PEER__:?}" -iname "0-0-0-0-${__CA_PORT__}.pem"); do
  mv "$f" "$(dirname "$f")/cacert.pem"
done

for f in $(find "${__CRYPTO_PEER__:?}" -iname "tls-0-0-0-0-${__TLSCA_PORT__}.pem"); do
  mv "$f" "$(dirname "$f")/tlscacert.pem"
done

for DIR in $(find "${__CRYPTO_PEER__:?}" -depth -type d); do
  [ -z "$DIR" ] && continue

  TMP_DIR=$(mktemp -d) || exit 1
  [ -z "$TMP_DIR" ] && exit 1

  if [[ $DIR == *"/tls" ]]; then
    mv "${DIR}/keystore/key.pem" "$TMP_DIR"
    mv "${DIR}/signcerts/cert.pem" "$TMP_DIR"
    mv "${DIR}/tlscacerts/tlscacert.pem" "${TMP_DIR}/ca.pem"
    mv "${DIR}/IssuerPublicKey" "$TMP_DIR"
    mv "${DIR}/IssuerRevocationPublicKey" "$TMP_DIR"

    rm -rf "$DIR" || exit 1
    mv "$TMP_DIR" "$DIR" || exit 1
  fi

  if [[ $DIR == *"/msp" ]]; then
    cp "${BIN}/config.yaml" "$DIR" || exit 1
  fi
done

mkdir -p "${__CRYPTO_PEER__}/vtb.ru/"{ca,tlsca} || exit 1
cp "${__TLSCA_SRV_HOME__}/tlsca-cert.pem" "${__CRYPTO_PEER__}/vtb.ru/tlsca/"
cp "${__CA_SRV_HOME__}/ca-cert.pem" "${__CRYPTO_PEER__}/vtb.ru/ca/"