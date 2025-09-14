#!/bin/bash

# SSH and Git configuration for user keys
setup_ssh_for_git() {
    local ssh_key_path=""
    local ssh_dir=""

    # Check if SSH keys are mounted from host machine
    if [ -d "/home/appuser/.ssh" ]; then
        ssh_dir="/home/appuser/.ssh"
        # Test if SSH directory has keys
        if [ -f "${ssh_dir}/id_rsa" ] || [ -f "${ssh_dir}/id_ed25519" ] || [ -f "${ssh_dir}/id_ecdsa" ]; then
            echo "Found SSH keys in /home/appuser/.ssh"

            # Skip permission changes - these are read-only host mounts
            echo "SSH keys mounted from host (read-only) - skipping permission changes"

            # Copy SSH config to appuser's home (without changing ownership of read-only files)
            mkdir -p /home/appuser/.ssh
            cp -r ${ssh_dir}/* /home/appuser/.ssh/ 2>/dev/null || true
            # Note: Can't chown read-only mounted files, but SSH should still work
        fi
    fi

    # Check if SSH keys are mounted as temp directory
    if [ -d "/tmp/.ssh" ]; then
        ssh_dir="/tmp/.ssh"
        echo "Found SSH keys in /tmp/.ssh"
        mkdir -p /home/appuser/.ssh
        cp -r ${ssh_dir}/* /home/appuser/.ssh/ 2>/dev/null || true
        chown -R appuser:appuser /home/appuser/.ssh
        chmod 700 /home/appuser/.ssh
    fi

    # Configure git to use SSH keys
    if [ -f "/home/appuser/.ssh/id_rsa" ] || [ -f "/home/appuser/.ssh/id_ed25519" ] || [ -f "/home/appuser/.ssh/id_ecdsa" ]; then
        echo "Configuring git to use SSH keys"

        # Set git config as appuser (no su needed since we're running as root)
        # Drop privileges to appuser for git config commands
        runuser -u appuser -- git config --global core.sshCommand "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
        runuser -u appuser -- git config --global user.name "${GIT_USER_NAME:-Docker User}"
        runuser -u appuser -- git config --global user.email "${GIT_USER_EMAIL:-docker@example.com}"

        # Set up SSH agent for passphrase handling
        if [ ! -n "$SSH_AGENT_PID" ]; then
            # Start SSH agent as appuser
            echo "Starting SSH agent for passphrase handling..."
            eval $(runuser -u appuser -- ssh-agent -s)
            runuser -u appuser -- ssh-add
        fi
    else
        echo "No SSH keys found, falling back to HTTPS"
        runuser -u appuser -- git config --global credential.helper store
    fi
}

# Set up SSH for git operations
setup_ssh_for_git

# Create necessary workspace directories (as root before USER switch)
echo "Setting up workspace directories..."
if [ -d "/workspaces" ]; then
    mkdir -p /workspaces/repos 2>/dev/null
    chmod 755 /workspaces 2>/dev/null
    chmod 755 /workspaces/repos 2>/dev/null
    # Don't chown - the volume is mounted from host, ownership stays as mounted
    echo "Workspace directories setup:"
    echo "  /workspaces/ - root volume mount"
    echo "  /workspaces/repos/ - git repositories directory"
    echo ""
else
    echo "Warning: /workspaces volume not mounted!"
fi

# Start fast-agent with custom config
cd /workspaces
exec fast-agent "$@"
