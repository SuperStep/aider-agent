FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install aider
RUN pip install git+https://github.com/paul-gauthier/aider.git

# Install MCP clients
# Install Python MCP client
RUN pip install git+https://github.com/sooperset/mcp-atlassian.git

# Install Node.js based MCP client (bitbucket-mcp)
RUN git clone https://github.com/MatanYemini/bitbucket-mcp.git /opt/bitbucket-mcp \
    && cd /opt/bitbucket-mcp \
    && npm install \
    && npm run build

# Set working directory
WORKDIR /workspace

# Copy configuration files
COPY . .

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set environment variables
ENV OPENROUTER_API_KEY=""
ENV MODEL="anthropic/claude-3-sonnet"

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["aider", "--mcp-config", "/config/mcp-config/mcp.json", "--message", "Welcome! I'm ready to help with your coding tasks. I have access to Bitbucket and Jira through MCP clients. The ai-code-review repository has been cloned to /workspace/ai-code-review."]
