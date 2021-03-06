#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

dir-empty "$__CA_ADM_HOME__" || exit 0
mkdir -p "$__CA_ADM_HOME__" || exit 1

CFG_SOURCE="${__CFG__}/ca-admin.yaml"
CFG_DIST="${__CA_ADM_HOME__}/fabric-ca-client-config.yaml"
[ ! -f "$CFG_DIST" ] && (cp "$CFG_SOURCE" "$CFG_DIST" || exit 1)
cd "$__CA_ADM_HOME__" || exit 1

export FABRIC_CA_CLIENT_BCCSP_DEFAULT="$__BCCSP_DEFAULT__"

fabric-ca-client enroll -u "https://ca-admin:ca-adminpw@${__CA_SCR__}" \
  --home "$__CA_ADM_HOME__" \
  --csr.keyrequest.algo "ecdsa" \
  --csr.keyrequest.size "256" \
  --csr.names "C=RU,ST=St. Petersburg,L=St. Petersburg,O=VTB Bank(PJSC)"
