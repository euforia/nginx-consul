#!/usr/bin/env bash
set -e

echo "Starting nginx"

export LD_LIBRARY_PATH="/usr/local/nginx/ext:$LD_LIBRARY_PATH"
exec /usr/local/nginx/sbin/nginx
