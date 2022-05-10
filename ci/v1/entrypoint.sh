#!/bin/sh
set -e

# entrypoint.sh
if [ "$1" = 'default' ]; then
  # do default thing here
  echo "Running default"
  exec python ci_test.py s1 30000 s2 30001 scp756-221
else
  echo "Running user supplied arg"
  # if the user supplied say /bin/bash
  exec "$@"
fi

