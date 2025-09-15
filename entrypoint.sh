#!/bin/bash
# Copy keys
cp -r /tmp/.ssh/ /root/.ssh
chmod 700 /root/.ssh

# Start fast-agent with custom config
cd /app
exec fast-agent "$@"
