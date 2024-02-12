#!/bin/bash
set -e

# 起動用スクリプト
# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
echo "$@"
exec "$@"
