#!/bin/bash

set -e

cd /data

cp -rf /tmp/mc-paper/* .
echo "eula=true" > eula.txt

if [[ ! -e server.properties ]]; then
    cp /tmp/server.properties .
fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi
if [[ -n "$SEED" ]]; then
    sed -i "/level-seed\s*=/ c level-seed=$SEED" /data/server.properties
fi

if [[ -n "$ENABLE_RCON" ]]; then
    sed -i "/enable-rcon\s*=/ c enable-rcon=$ENABLE_RCON" /data/server.properties
fi

java $JVM_OPTS -jar ServerInstall-paper.jar nogui
