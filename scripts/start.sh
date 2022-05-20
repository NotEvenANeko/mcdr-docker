#!/bin/sh
isLatest()
{
  if [ -z "$1" ]; then
    return 0
  fi
  processedInput=$(echo $1 | tr '[:lower:]' '[:upper:]')
  if [ "$processedInput" = "LATEST" ]; then
    return 0
  else
    return 1
  fi
}

echo "Starting server setup..."
OUTPUT=$(SETUP_ONLY=true /start)

if [ "$?" -ne 0 ]; then
  echo "Setup failed, exiting..."
  exit 1
fi

if isLatest $MCDR_VERSION; then
  parsedVersion=$(echo $( \
      curl -sS https://api.github.com/repos/Fallen-Breath/MCDReforged/releases/latest |\
      grep "tag_name" |\
      cut -d'v' -f2 |\
      cut -d'"' -f1 \
    ) \
  )
else
  parsedVersion=$MCDR_VERSION
fi

echo "Installing MCDReforged $parsedVersion..."

pip install mcdreforged==$parsedVersion
curl -sSLo /tmp/mcdr/source.tar.gz https://github.com/Fallen-Breath/MCDReforged/archive/refs/tags/v$parsedVersion.tar.gz

chown -R minecraft:minecraft /tmp/mcdr
chown minecraft:minecraft /mcdr
gosu minecraft:minecraft /start-mcdr-server.sh "$OUTPUT"