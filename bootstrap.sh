#!/bin/bash
# bootstrap.sh - Initial setup script

# Exit on any error
set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Starting OCI Development Environment Setup...${NC}"

# Check prerequisites
check_prerequisites() {
    local missing_tools=()
    
    for tool in curl jq unzip; do
        if ! command -v $tool &> /dev/null; then
            missing_tools+=($tool)
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        echo -e "${RED}Missing required tools: ${missing_tools[*]}${NC}"
        echo "Installing missing tools..."
        sudo apt update
        sudo apt install -y "${missing_tools[@]}"
    fi
}

# Create necessary directories
setup_directories() {
    mkdir -p ~/.oci
    mkdir -p ~/.ssh
    mkdir -p ~/workspace/terraform
}

# Generate SSH key if it doesn't exist
generate_ssh_key() {
    if [ ! -f ~/.ssh/oci_key ]; then
        ssh-keygen -t ed25519 -f ~/.ssh/oci_key -N "" -C "oci-dev-environment"
        echo -e "${GREEN}SSH key generated at ~/.ssh/oci_key${NC}"
    else
        echo "SSH key already exists"
    fi
}

# Generate API key for OCI
generate_oci_api_key() {
    if [ ! -f ~/.oci/oci_api_key.pem ]; then
        openssl genrsa -out ~/.oci/oci_api_key.pem 2048
        chmod 600 ~/.oci/oci_api_key.pem
        openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem
        echo -e "${GREEN}OCI API keys generated in ~/.oci/${NC}"
        
        echo -e "${GREEN}Public key for OCI (copy this to OCI console):${NC}"
        cat ~/.oci/oci_api_key_public.pem
        
        echo -e "${GREEN}API key fingerprint:${NC}"
        openssl rsa -pubout -outform DER -in ~/.oci/oci_api_key.pem | openssl md5 -c
    else
        echo "OCI API key already exists"
    fi
}

# Download and configure Terraform
setup_terraform() {
    if ! command -v terraform &> /dev/null; then
        echo "Installing Terraform..."
        sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
        wget -O- https://apt.releases.hashicorp.com/gpg | \
            gpg --dearmor | \
            sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
            https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
            sudo tee /etc/apt/sources.list.d/hashicorp.list
        sudo apt-get update && sudo apt-get install -y terraform
    fi
}

# Create Terraform variables file template
create_terraform_vars() {
    cat > ~/workspace/terraform/terraform.tfvars.template << 'EOF'
tenancy_ocid        = "your-tenancy-ocid"
user_ocid           = "your-user-ocid"
fingerprint         = "your-api-key-fingerprint"
private_key_path    = "~/.oci/oci_api_key.pem"
region              = "your-chosen-region"
ssh_public_key_path = "~/.ssh/oci_key.pub"
ubuntu_image_id     = "ocid1.image.oc1..." # Fill in with correct OCID
EOF
}

# Main execution
main() {
    check_prerequisites
    setup_directories
    generate_ssh_key
    generate_oci_api_key
    setup_terraform
    create_terraform_vars
    
    echo -e "${GREEN}Setup complete!${NC}"
    echo -e "\nNext steps:"
    echo "1. Copy your API key fingerprint shown above"
    echo "2. Upload your API public key to OCI console (Identity & Security > Users > API Keys)"
    echo "3. Get your tenancy OCID from OCI console (Profile > Tenancy)"
    echo "4. Get your user OCID from OCI console (Profile > User Settings)"
    echo "5. Edit ~/workspace/terraform/terraform.tfvars.template with your values and rename to terraform.tfvars"
    echo "6. Run the infrastructure deployment script"
}

main