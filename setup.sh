#!/bin/bash
# setup.sh
# runs ON the remote instance

# System configuration script that runs ON the remote instance
# - Updates system packages
# - Installs core tools: git, curl, wget, tmux, zsh, unzip, jq, docker
# - Installs and configures AWS CLI
# - Installs Terraform
# - Configures Docker for ubuntu user
# - Sets up Oh My Zsh
# - Adds useful aliases to .zshrc


# Update system
apt update && apt upgrade -y

# Install basic tools
apt install -y git curl wget tmux zsh unzip jq docker.io

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Add to setup.sh after AWS CLI installation
mkdir -p /home/ubuntu/.aws
chown ubuntu:ubuntu /home/ubuntu/.aws
chmod 700 /home/ubuntu/.aws

# Install Terraform
apt-get update && apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install -y terraform

# Configure Docker
usermod -aG docker ubuntu
systemctl enable docker
systemctl start docker

# Setup Oh My Zsh
su - ubuntu -c 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

# Configure environment
cat >> /home/ubuntu/.zshrc << 'EOF'
alias tf="terraform"
alias aws-whoami="aws sts get-caller-identity"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfd="terraform destroy"
alias tfmt="terraform fmt"
EOF

# Configure tmux
cat > /home/ubuntu/.tmux.conf << 'EOF'
set -g mouse on
set-option -g history-limit 5000
bind | split-window -h
bind - split-window -v
EOF

# Create workspace
mkdir -p /home/ubuntu/workspace/terraform
chown -R ubuntu:ubuntu /home/ubuntu/workspace
chown -R ubuntu:ubuntu /home/ubuntu/.zshrc
chown -R ubuntu:ubuntu /home/ubuntu/.tmux.conf