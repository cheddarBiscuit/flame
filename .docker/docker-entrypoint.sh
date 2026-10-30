#!/bin/sh
set -e

# Run as PUID:PGID (default 1000:1000, the image's "node" user).
# Set PUID=0 to keep running as root, e.g. on Synology shares whose ACLs deny
# non-root users even when the files are owned by their UID.
PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

if [ "$PUID" = "0" ]; then
  echo "Starting Flame as root (PUID=0)"
  exec node server.js
fi

# chown can fail on ACL-managed shares; access may already be granted there
chown -R "$PUID:$PGID" /app/data /app/public ||
  echo "Warning: could not chown /app/data and /app/public to $PUID:$PGID"

echo "Starting Flame as $PUID:$PGID"
exec su-exec "$PUID:$PGID" node server.js
