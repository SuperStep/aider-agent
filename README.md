# Aider Agent with OpenRouter and MCP Integration

This Docker container provides an aider agent configured to work with OpenRouter, plus MCP clients for Bitbucket and Jira integration.

## Setup

1. Copy the environment template:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your actual credentials:
   ```bash
   # Required
   OPENROUTER_API_KEY=your_openrouter_api_key_here

   # Optional - defaults to Claude 3 Sonnet
   MODEL=anthropic/claude-3-sonnet

   # Bitbucket MCP Configuration
   BITBUCKET_USER=your_bitbucket_username
   BITBUCKET_APP_PASSWORD=your_bitbucket_app_password
   BITBUCKET_WORKSPACE=your_workspace_name

   # Jira MCP Configuration
   JIRA_EMAIL=your_jira_email@example.com
   JIRA_API_TOKEN=your_jira_api_token
   JIRA_SERVER_URL=https://your-company.atlassian.net
   ```

3. Update the MCP configuration files in `mcp-config/` with your credentials:
   - `mcp-config/bitbucket/config.json`
   - `mcp-config/jira/config.json`
   - `mcp-config/mcp.json`

## Running the Container

```bash
# Build and run with docker-compose
docker-compose up --build

# Or use docker directly
docker build -t aider-agent .
docker run -it --env-file .env -v $(pwd)/workspace:/workspace aider-agent
```

## Features

### Aider Agent
- Connected to OpenRouter for AI assistance
- Configurable model selection
- Persistent workspace for file operations

### MCP Integrations

#### Bitbucket
- Create and manage pull requests
- Repository operations
- Issue management

#### Jira
- Read ticket contexts and details
- Issue tracking and management
- Project board integration

## Usage

Once the container is running, you'll have access to aider's full functionality with MCP-powered Bitbucket and Jira integration. The agent can help you:

- Generate and modify code
- Create pull requests in Bitbucket
- Read and manipulate Jira tickets
- Perform repository operations

## MCP Configuration

The MCP servers are configured through the files in `mcp-config/`:

- **mcp.json**: Main configuration file
- **bitbucket/config.json**: Bitbucket-specific settings
- **jira/config.json**: Jira-specific settings

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| OPENROUTER_API_KEY | Your OpenRouter API key | Yes |
| MODEL | AI model to use | No (defaults to Claude 3 Sonnet) |
| BITBUCKET_USER | Bitbucket username | No |
| BITBUCKET_APP_PASSWORD | Bitbucket app password | No |
| BITBUCKET_WORKSPACE | Bitbucket workspace name | No |
| JIRA_EMAIL | Jira account email | No |
| JIRA_API_TOKEN | Jira API token | No |
| JIRA_SERVER_URL | Jira server URL | No |

## Troubleshooting

1. **Docker issues**: Ensure Docker is running and you have proper permissions
2. **API keys**: Verify all your API keys and tokens are correct
3. **MCP errors**: Check the MCP configuration files for proper formatting
4. **Network issues**: Ensure the container can reach external APIs

## License

MIT License
