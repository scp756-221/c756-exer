#!/bin/sh
set -e

# entrypoint.sh
if [ "$1" = 'default' ]; then
  # do default thing here
  echo "Running default"
  exec python app.py 30002
else
  echo "Running user supplied arg"
  # if the user supplied say /bin/bash
  exec "$@"
fi

