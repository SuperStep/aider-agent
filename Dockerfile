FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install aider
RUN pip install aider-chat

# Install MCP clients
RUN pip install git+https://github.com/MatanYemini/bitbucket-mcp.git \
    && pip install git+https://github.com/sooperset/mcp-atlassian.git

# Set working directory
WORKDIR /workspace

# Copy configuration files
COPY . .

# Set environment variables
ENV OPENROUTER_API_KEY=""
ENV MODEL="anthropic/claude-3-sonnet"

# Start command
CMD ["aider", "--message", "Ready to help with coding tasks!"]
