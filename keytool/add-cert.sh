#!/bin/bash

echo "#################################################################"
echo "# Импортировать сертификат в хранилище                          #"
echo "#################################################################"

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/util.sh"

ALIAS=$1
FILE_CERT=$2

[ -z "$ALIAS" ] && echo "Не передан alias сущности: ./script [alias] [path_file]" && exit 1
[ -z "$FILE_CERT" ] && echo "Не указан файл сертификата: ./script [alias] [path_file]" && exit 1
[ ! -f "$FILE_CERT" ] && echo "Файл сертификата '${FILE_CERT}' не существует " && exit 1

keytool -importcert -noprompt -keystore "$__STORE__" -storepass "$__PIN__" \
    -alias "$ALIAS" \
    -file "$FILE_CERT"
