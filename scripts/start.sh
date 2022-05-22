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

resolveHandler()
{
  case "$1" in
    "VANILLA" | "FABRIC")
      echo "vanilla_handler"
    ;;
    "FORGE")
      echo "forge_handler"
    ;;
    "BUKKIT" | "SPIGOT")
      if [ -z "$2" ] || [ "$2" = "LATEST" ]; then
        echo "bukkit14_handler"
      fi
      MINOR_VERSION=echo $2 | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sed -r 's/^[0-9]+\.([0-9]+)\.[0-9]+$/\1/'
      if [ -z "MINOR_VERSION" ]; then
        echo "Invalid version number"
        exit 1
      fi
      if [ $(($MINOR_VERSION)) -ge 14 ]; then
        echo "bukkit14_handler"
      else
        echo "bukkit_handler"
      fi
    ;;
    "PAPER" | "MOHIST")
      echo "bukkit_handler"
    ;;
    "CATSERVER")
      echo "cat_server_handler"
    ;;
    *)
      echo "vanilla_handler"
    ;;
  esac
}

umask 0002

echo "Starting server setup..."
# Changing uid and gid of minecraft
OUTPUT=$(SETUP_ONLY=true /start)

if [ "$?" -ne 0 ]; then
  echo "Setup failed, exiting..."
  exit 1
fi

if [ -n "$BOOT_FROM_SOURCE" ]; then
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
  echo "Boot from source enabled"
  echo "Fetch source code, version $parsedVersion..."
  curl -sSLo /tmp/mcdr/source.tar.gz https://github.com/Fallen-Breath/MCDReforged/archive/refs/tags/v$parsedVersion.tar.gz
  tar --skip-old-files -xzf /tmp/mcdr/source.tar.gz -C /mcdr --strip-components=1
  if [ "$?" -ne 0 ]; then
    echo "Err: failed to fetch source code, exiting..."
    exit 1
  fi
  pip install -qr /mcdr/requirements.txt
else
  if isLatest $MCDR_VERSION; then
    echo "Installing latest MCDReforged..."
    pip install -q mcdreforged
  else
    echo "Installing MCDReforged $MCDR_VERSION..."
    pip install -q mcdreforged==$MCDR_VERSION
  fi
fi

START_COMMAND=$(echo $OUTPUT | grep -oE 'SETUP_ONLY: .+' | sed -r 's/^SETUP_ONLY: (.+)$/\1/')
if [ -z "$START_COMMAND" ]; then
  echo "err: command is empty, exiting..."
  exit 1
fi

HANDLER=$(resolveHandler $TYPE $VERSION)
if [ -z "$HANDLER" ]; then
  echo "err: handler is empty, exiting..."
  exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
  runAsUser=minecraft
  runAsGroup=minecraft

  if [ -n "$UID" ] && [ "$UID" -eq 0 ]; then
    runAsUser=root
  fi

  if [ -n "$GID" ] && [ "$GID" -eq 0 ]; then
    runAsGroup=root
  fi

  echo "Running MCDReforged as '$runAsUser'"
  echo "Changing owner of /mcdr to '$(id -u $runAsUser):$(id -g $runAsUser)'"

  chown -R $runAsUser:$runAsGroup /mcdr
  chown -R $runAsUser:$runAsGroup /tmp/mcdr
  gosu $runAsUser:$runAsGroup /start-mcdr-server.sh "$START_COMMAND" "$HANDLER"
else
  /start-mcdr-server.sh "$START_COMMAND" "$HANDLER"
fi