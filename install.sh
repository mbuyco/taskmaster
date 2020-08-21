#!/bin/sh

TASKM_DIR="$HOME/.taskmaster"

# Initialize JSON datastore
if [ ! -d "$TASKM_DIR/store" ]; then
	mkdir "$TASKM_DIR/store"
fi

if [ ! -f "$TASKM_DIR/store/tasks.json" ]; then
	touch "$TASKM_DIR/store/tasks.json"
	echo '{ "tasks": [] }' > "$TASKM_DIR/store/tasks.json"
fi

# Install executable
if [ -d "$TASKM_DIR/.taskmaster" ]; then
	sudo ln -s "$TASKM_DIR/bin/taskmaster.rb" /usr/local/bin/taskm
fi

