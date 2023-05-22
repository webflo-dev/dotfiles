#!/usr/bin/env bash

DESTDIR=$HOME/.local/bin
TARGET=${DESTDIR}/docker-compose

curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ${TARGET}
chmod u+x ${TARGET}
