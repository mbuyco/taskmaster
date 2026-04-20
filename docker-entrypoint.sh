#!/bin/sh

set -eu

STORE_DIR="/app/store"
STORE_FILE="$STORE_DIR/tasks.json"

mkdir -p "$STORE_DIR"

if [ ! -f "$STORE_FILE" ]; then
  printf '{ "tasks": [] }\n' > "$STORE_FILE"
fi

exec bundle exec ruby /app/bin/taskmaster.rb "$@"
