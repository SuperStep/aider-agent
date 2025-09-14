# Fast Agent Docker Image with MCP Integrations

This Docker image provides a complete fast-agent setup with integrated MCP servers for Bitbucket and JIRA/Confluence.

## Features

- **Fast Agent**: MCP-enabled agent framework for building effective agents
- **Bitbucket MCP**: Integration for creating and managing pull requests
- **JIRA MCP**: Integration for reading ticket contexts
- **Python-based**: Built on Python 3.13.7 with uv package manager
- **Multi-platform**: Supports both Python and Node.js for different MCP servers

## Quick Start

### Using Docker Compose (Recommended)

1. Clone this repository or create the files locally
2. Set up environment variables:

```bash
# Create a .env file
cp .env.example .env

# Edit .env with your credentials (see below)
```

3. Run the container:

```bash
docker-compose up
```

### Using Docker directly

```bash
# Build the image
docker build -t fast-agent-mcp .

# Run with environment variables
docker run --rm \
  -e GOOGLE_API_KEY=your_google_api_key \
  -e BITBUCKET_TOKEN=your_token \
  -e BITBUCKET_WORKSPACE=your_workspace \
  -e JIRA_URL=https://your-domain.atlassian.net \
  -e JIRA_USERNAME=your_email@example.com \
  -e JIRA_TOKEN=your_api_token \
  -p 8000:8000 \
  fast-agent-mcp
```

## Configuration

### Environment Variables

#### Google API Configuration (required)
- `GOOGLE_API_KEY`: Your Google Gemini API key (get from: https://aistudio.google.com/app/apikey)

#### Bitbucket MCP (for pull requests)
- `BITBUCKET_TOKEN`: Your Bitbucket token
- `BITBUCKET_WORKSPACE`: The Bitbucket workspace to work with

#### JIRA MCP (for ticket reading)
- `JIRA_URL`: Your JIRA instance URL (e.g., https://your-domain.atlassian.net)
- `JIRA_USERNAME`: Your JIRA email address
- `JIRA_TOKEN`: Your JIRA API token

#### Confluence MCP (optional)
- `CONFLUENCE_URL`: Your Confluence instance URL
- `CONFLUENCE_USERNAME`: Your Confluence email address
- `CONFLUENCE_TOKEN`: Your Confluence API token

### Custom Configuration

You can customize the fast-agent configuration by mounting your own config file:

```bash
docker run --rm \
  # ... environment variables ...
  -v $(pwd)/my-config.yaml:/app/fastagent.config.yaml:ro \
  fast-agent-mcp
```

## Available MCP Tools

### Bitbucket MCP
- Create pull requests
- List repositories and branches
- Get pull request details
- Add comments and reviewers
- Manage pull request states

### JIRA MCP
- Search issues by JQL
- Get issue details and comments
- Update issue status
- Create new issues
- Transition issues through workflows

## Usage Examples

Once the container is running, you can interact with the agent through various modes:

### Interactive Mode (default)
```bash
docker-compose exec fast-agent fast-agent go
```

### Command Line Mode
```bash
docker-compose exec fast-agent fast-agent go --message "Create a pull request for my changes"
```

### With Custom Agent
```bash
docker-compose exec fast-agent fast-agent setup
# This creates example agents in the container
```

## Building from Source

To build this image yourself:

```bash
git clone <this-repo>
cd <this-repo>

# Build main Docker image
docker build -t fast-agent-mcp .
```

## MCP Server Details

### fast-agent
- Repository: https://github.com/evalstate/fast-agent
- Python-based agent framework with MCP support

### bitbucket-mcp
- Repository: https://github.com/MatanYemini/bitbucket-mcp
- Node.js-based MCP server for Bitbucket Cloud and Server

### mcp-atlassian
- Repository: https://github.com/sooperset/mcp-atlassian
- Python-based MCP server for JIRA and Confluence

## Development

To modify the setup:

1. Edit `fastagent.config.yaml` for MCP server configuration
2. Edit `Dockerfile` for build customizations
3. Edit `docker-compose.yml` for runtime configuration

## Troubleshooting

### Common Issues

1. **Missing environment variables**: Ensure all required environment variables are set for the MCP servers you want to use.

2. **Network access**: The container needs outbound internet access for API calls to Bitbucket, JIRA, and LLM providers.

3. **Permission denied**: Make sure the entrypoint script and MCP executables have proper execute permissions.

### Logs

View container logs:
```bash
docker-compose logs fast-agent
```

### Debugging MCP Servers

You can test individual MCP servers by modifying the configuration to disable others temporarily.

## License

This project integrates multiple components with their respective licenses:

- fast-agent: Apache-2.0
- bitbucket-mcp: MIT
- mcp-atlassian: MIT
