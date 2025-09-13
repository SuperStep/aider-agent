#!/bin/bash

# Set workspace directory
WORKSPACE_DIR="/workspace"
AI_CODE_REVIEW_DIR="$WORKSPACE_DIR/ai-code-review"

# Check if repository already exists
if [ ! -d "$AI_CODE_REVIEW_DIR" ]; then
    echo "Cloning ai-code-review repository..."
    cd $WORKSPACE_DIR
    git clone git@github.com:SuperStep/ai-code-review.git
    echo "Repository cloned successfully!"
else
    echo "Repository already exists, skipping clone."
fi

# Execute the original command
exec "$@"
