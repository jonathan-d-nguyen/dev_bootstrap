#!/bin/bash
# deploy.sh - Infrastructure deployment script

# Exit on any error
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

WORKSPACE_DIR=~/workspace/terraform

# Download infrastructure code
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
        curl -sL "https://raw.githubusercontent.com/your-repo/$file" -o "$temp_dir/$file"
    done
    
    # Move files to workspace
    mv $temp_dir/* $WORKSPACE_DIR/
    rm -rf $temp_dir
}

# Initialize and apply Terraform
deploy_infrastructure() {
    cd $WORKSPACE_DIR
    
    # Check if terraform.tfvars exists
    if [ ! -f "terraform.tfvars" ]; then
        echo -e "${RED}Error: terraform.tfvars not found${NC}"
        echo "Please create terraform.tfvars from terraform.tfvars.template"
        exit 1
    }
    
    # Initialize Terraform
    terraform init
    
    # Apply infrastructure
    terraform apply -auto-approve
    
    # Save IP address
    terraform output instance_public_ip > instance_ip.txt
    
    echo -e "${GREEN}Infrastructure deployment complete!${NC}"
    echo "Instance IP: $(cat instance_ip.txt)"
}

# Wait for instance to be ready
wait_for_instance() {
    local ip=$(cat $WORKSPACE_DIR/instance_ip.txt)
    echo "Waiting for instance to be ready..."
    
    while ! nc -z -w5 $ip 22; do
        echo "Still waiting for SSH access..."
        sleep 10
    done
    
    # Add small delay to ensure services are running
    sleep 30
    
    echo -e "${GREEN}Instance is ready!${NC}"
}

# Main execution
main() {
    download_infra_code
    deploy_infrastructure
    wait_for_instance
    
    echo -e "\nSetup complete! To connect to your instance:"
    echo "ssh -i ~/.ssh/oci_key ubuntu@$(cat $WORKSPACE_DIR/instance_ip.txt)"
}

main