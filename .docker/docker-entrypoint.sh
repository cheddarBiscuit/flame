#!/bin/sh
set -e

# Run as PUID:PGID (default 1000:1000, the image's "node" user).
# Set PUID=0 to keep running as root, e.g. on Synology shares whose ACLs deny
# non-root users even when the files are owned by their UID.
PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

if [ "$PUID" = "0" ]; then
  exec node server.js
fi

chown -R "$PUID:$PGID" /app/data /app/public
exec su-exec "$PUID:$PGID" node server.js
