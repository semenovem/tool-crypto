#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/../util.sh" ".."

bash "${BIN}/clean.sh" || exit 1

softhsm2-util --delete-token --token "$__HSM_SLOT__"
