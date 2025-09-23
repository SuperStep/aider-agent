#!/bin/bash
# Copy keys
cp -r /tmp/.ssh/ /root/.ssh
chmod 700 /root/.ssh

# Start gpt2giga service in background
echo "### Starting gpt2giga proxy"
cd /app
gpt2giga \
    --host 127.0.0.1 \
    --port 8090 \
    --verbose \
    --base-url https://gigachat.devices.sberbank.ru/api/v1 \
    --model GigaChat-Max \
    --timeout 300 \
    --embeddings EmbeddingsGigaR &

# Start fast-agent with custom config
cd /app
exec fast-agent "$@"
