#!/bin/bash
# deploy2.sh - Infrastructure deployment script with modularity
# runs FROM local machine

# Local deployment orchestration script; 
# - Downloads infrastructure code from GitHub
# - Validates directory structure
# - Handles tfvars file management
# - Runs Terraform commands (init, plan, apply)
# - Captures instance IP to instance_ip.txt
# - Contains error handling and color output


# Exit on any error
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Function to download infrastructure code (unchanged)
download_infra_code() {
    local infra_files=(
        "main.tf"
        "variables.tf"
        "setup.sh"
    )
    
    # Create temporary directory
    local temp_dir=$(mktemp -d)
    
    # Download each file
    for file in "${infra_files[@]}"; do
        curl -sL "https://github.com/jonathan-d-nguyen/dev_bootstrap/$file" -o "$temp_dir/$file"
    done
    
    # Move files to workspace
    mv $temp_dir/* $WORKSPACE_DIR/
    rm -rf $temp_dir
}

# Function to validate directory structure
validate_directory() {
  local dir="$1"
  if [ ! -f "${dir}/main.tf" ]; then
    echo -e "${RED}Error: main.tf not found in ${dir}${NC}"
    exit 1
  fi
}

# Function to check for environment variables
get_tfvars_file() {
  local env="$1"
  local dir="$2"
  if [ -f "${dir}/config/${env}.tfvars" ]; then
    TFVARS_FILE="${dir}/config/${env}.tfvars"
  elif [ -f "${dir}/terraform.tfvars" ]; then
    TFVARS_FILE="${dir}/terraform.tfvars"
  else
    echo -e "${RED}Error: No tfvars file found for environment ${env}${NC}"
    exit 1
  fi
}

# Function to deploy infrastructure
deploy_infrastructure() {
  local dir="$1"
  local tfvars_file="$2"
  cd "$dir"
  terraform init
  terraform plan -var-file="$tfvars_file"
  terraform apply -var-file="$tfvars_file" -auto-approve
  echo -e "${GREEN}Infrastructure deployment complete!${NC}"
  terraform output -raw instance_public_ip > instance_ip.txt
  echo "Instance IP: $(cat instance_ip.txt)"
}

# Function to wait for instance readiness
wait_for_instance() {
  local ip=$(cat instance_ip.txt)
  echo "Waiting for instance to be ready..."
  # ... (existing code from original script)
  echo -e "${GREEN}Instance is ready!${NC}"
}

# Main execution with parameter handling
WORKSPACE_DIR=${1:-"$(pwd)"}
ENV=${2:-"dev"}

validate_directory "$WORKSPACE_DIR"
get_tfvars_file "$ENV" "$WORKSPACE_DIR"

deploy_infrastructure "$WORKSPACE_DIR" "$TFVARS_FILE"
wait_for_instance

echo -e "\nSetup complete! To connect to your instance:"
echo "ssh -i ~/.ssh/oci_key ubuntu@$(cat $WORKSPACE_DIR/instance_ip.txt)"