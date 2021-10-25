#!/bin/bash

BIN=$(dirname "$([[ $0 == /* ]] && echo "$0" || echo "$PWD/${0#./}")")
source "${BIN}/util.sh" ""

DEST="crypto"

[ -z "$DEST" ] &&
  echo "Не указана директория, куда скопировать крипто-материалы" &&
  exit 1

[[ "$DEST" != /* ]] && DEST="${BIN}/${DEST}"

[ -d "$DEST" ] && [ "$(ls "$DEST")" ] && echo "Директория [$DEST] не пуста" && exit 1

if [ ! -d "$DEST" ]; then
  [ ! -d "$(dirname "$DEST")" ] &&
    echo "Указанная директория не имеет родительской директории" &&
    exit 1

  mkdir -p "$DEST" || exit 1
fi

set -o allexport
source "${BIN}/project.properties"
set +o allexport

LOCAL=
ID=$(docker container ls -f name="^${DOCKER_CONTAINER_NAME}\$" -q) || exit 1
if [ -z "$ID" ]; then
  echo "Контейнер не запущен, пробуем запустить"

  make DETACH="-d" CMD="bash" dev
  LOCAL=true

  sleep 1
fi

docker cp "${DOCKER_CONTAINER_NAME}:${__CRYPTO__}/." "$DEST"

[ "$LOCAL" ] && (docker stop "$DOCKER_CONTAINER_NAME" || exit 1)
