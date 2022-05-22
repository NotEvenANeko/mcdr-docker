#!/bin/sh
echo "Using start command '$1'"
echo "Using handler '$2'"

mkdir -p /mcdr/config
mkdir -p /mcdr/logs
mkdir -p /mcdr/plugins

if [ -f "/mcdr/config.yml" ]; then
  echo "Config file 'config.yml' exists, overriding start command and handler..."
else
  echo "Config file 'config.yml' does not exist, using default config"
  cat /tmp/mcdr/config.yml > /mcdr/config.yml
fi

sed -i "/^start_command:/ s,^start_command:.*$,start_command: \"$1\"," /mcdr/config.yml
sed -i "/handler:/s/^handler:.*$/handler: \"$2\"/" /mcdr/config.yml

if [ -f "/mcdr/permission.yml" ]; then
  echo "Config file 'permission.yml' exists"
else
  echo "Config file 'permission.yml' does not exist, using default config"
  cat /tmp/mcdr/permission.yml > /mcdr/permission.yml
fi

if [ -n "$BOOT_FROM_SOURCE" ]; then
  echo "Starting setup..."
  python3 setup.py egg_info
  if [ "$?" -ne 0 ]; then
    echo "err: setup failed, exiting..."
    exit 1
  fi
  echo "Starting main server..."
  python3 MCDReforged.py
else
  echo "Starting main server..."
  python3 -m mcdreforged
fi