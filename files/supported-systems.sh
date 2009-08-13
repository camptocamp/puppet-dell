#!/bin/sh

URL="http://linux.dell.com/repo/hardware/latest"

# Fetch the list of known systems:

elinks -dump -no-references $URL | \
  grep 'ven_0x1028' | \
  sed 's/.*0x1028\.dev_\([0-9a-z]\+\)\/.*/\1/' | \

  while read id; do
# Loop through the list to find which ones have a srvadmin directory:
    if curl -sI $URL/system.ven_0x1028.dev_$id/rh50/srvadmin/ | fgrep "200 OK" > /dev/null; then
      echo -n "\"$id\", "
    fi
  done

