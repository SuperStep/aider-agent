# Alternative Dockerfile using Python 3.13
FROM python:3.13-slim

# Install system dependencies with retries
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        ca-certificates \
        gnupg \
        build-essential \
        openssh-client \
        && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install uv package manager for Python
RUN pip install --no-cache-dir uv

# Set working directory
WORKDIR /app

# Copy fast-agent source
COPY fast-agent/ ./fast-agent/

# Install fast-agent dependencies using uv
WORKDIR /app/fast-agent
RUN uv pip install --system --no-cache-dir -e .

# Copy Bitbucket Server MCP server
WORKDIR /app
COPY bitbucket-server-mcp/ ./bitbucket-server-mcp/

# Build Bitbucket Server MCP server
WORKDIR /app/bitbucket-server-mcp
RUN npm install && npm run build

# Copy JIRA MCP server
WORKDIR /app
COPY mcp-atlassian/ ./mcp-atlassian/

# Install JIRA MCP server dependencies using uv
WORKDIR /app/mcp-atlassian
RUN uv pip install --system --no-cache-dir -e .

# Copy gpt2giga service
WORKDIR /app
RUN uv pip install git+https://github.com/ai-forever/gpt2giga.git --system

# Create working directory for the application
WORKDIR /app

# Copy configuration file
COPY fastagent.config.yaml /app/fastagent.config.yaml

# Copy and make entrypoint executable as root (before USER switch)
COPY entrypoint.sh /app/entrypoint.sh

# Now make entrypoint executable AFTER user creation and chown
RUN chmod +x /app/entrypoint.sh

# Expose port if needed (fast-agent may expose ports)
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD fast-agent --help || exit 1

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

# Default command to start interactive session
CMD ["go"]
