#!/bin/bash
set -e

PROMPT="(docker-compose)> "

echo "-----> Launching docker-compose shell."
echo "-----> All commands will be prefixed by docker-compose."
echo "-----> Use ctrl-d or ctrl-c to exit"

while read -p "$PROMPT" line; do
  docker-compose $line
done

echo
