#!/bin/sh
echo "Starting server setup..."
OUTPUT=$(SETUP_ONLY=true /start)

if [ "$?" -ne 0 ]; then
  echo "Setup failed, exiting..."
  exit 1
fi

chown -R minecraft:minecraft /tmp/mcdr
chown minecraft:minecraft /mcdr
gosu minecraft:minecraft /start-mcdr-server.sh "$OUTPUT"