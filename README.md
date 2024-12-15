<!-- Back to top link -->

<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <h3 align="center">Mobile-First AWS Development Environment on Oracle Cloud</h3>

  <p align="center">
    A turnkey solution for creating a robust, mobile-accessible AWS development environment using Oracle Cloud's Always Free tier.
    <br />
    <a href="#1-about-the-project"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/jonathan-d-nguyen/dev_bootstrap/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/jonathan-d-nguyen/dev_bootstrap/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#1-about-the-project">About The Project</a>
      <ul>
        <li><a href="#11-built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#2-quick-start">Quick Start</a>
      <ul>
        <li><a href="#21-prerequisites">Prerequisites</a></li>
        <li><a href="#22-basic-setup">Basic Setup</a></li>
      </ul>
    </li>
    <li>
      <a href="#3-deployment--operations">Deployment & Operations</a>
      <ul>
        <li><a href="#31-full-installation-steps">Full Installation Steps</a></li>
        <li><a href="#32-testing--verification">Testing & Verification</a></li>
        <li><a href="#33-troubleshooting">Troubleshooting</a></li>
        <li><a href="#34-maintenance">Maintenance</a></li>
        <li><a href="#35-cleanup">Cleanup</a></li>
      </ul>
    </li>
    <li><a href="#4-roadmap">Roadmap</a></li>
    <li><a href="#5-contributing">Contributing</a></li>
    <li><a href="#6-license">License</a></li>
    <li><a href="#7-contact">Contact</a></li>
    <li><a href="#8-acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

## 1. About The Project

This repository provides an automated solution for setting up a complete AWS development environment using Oracle Cloud Infrastructure's Always Free tier. It's designed specifically for mobile-first development, allowing developers to work effectively from iOS devices while leveraging the power of cloud computing.

Key Features:

- Automated infrastructure deployment using Terraform
- Mobile-optimized development environment with tmux and zsh
- Pre-configured AWS CLI and Terraform setup
- Secure SSH access management
- Cost-effective using OCI's Always Free resources

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### 1.1. Built With

- [![Terraform][Terraform.io]][Terraform-url]
- [![Docker][Docker.io]][Docker-url]
- [![Shell Script][Shell.io]][Shell-url]
- [![Oracle Cloud][OCI.io]][OCI-url]
- [![AWS][AWS.io]][AWS-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 2. Quick Start

### 2.1. Prerequisites

- Oracle Cloud Account
  - Valid email address
  - Credit/debit card (for verification only)
  - Mobile phone number
- iOS Device with SSH Client
  - Termius, Blink Shell, or a-Shell
  - Working Copy (optional for Git)
- Basic command line knowledge

### 2.2. Basic Setup

1. Clone the repository

   ```sh
   git clone https://github.com/jonathan-d-nguyen/dev_bootstrap.git
   cd dev_bootstrap.git
   ```

2. Run the bootstrap script

   ```sh
   ./bootstrap.sh
   ```

3. Deploy infrastructure
   ```sh
   ./deploy.sh
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 3. Deployment & Operations

### 3.1. Full Installation Steps

1. Initial OCI Setup

   ```sh
   # Generate API and SSH keys
   ./bootstrap.sh

   # Follow prompts to:
   # - Upload API key to OCI console
   # - Note down OCIDs
   # - Configure region
   ```

2. Infrastructure Deployment

   ```sh
   # Deploy using Terraform
   ./deploy.sh

   # Note the output IP address
   ```

3. Environment Configuration

   ```sh
   # Connect to instance
   ssh -i ~/.ssh/oci_key ubuntu@<instance_ip>

   # Verify installation
   aws --version
   terraform --version
   ```

### 3.2. Testing & Verification

1. Verify SSH Access

   ```sh
   ssh -i ~/.ssh/oci_key ubuntu@<instance_ip> echo "Connection successful"
   ```

2. Check AWS Configuration

   ```sh
   aws configure list
   aws sts get-caller-identity
   ```

3. Verify Development Tools
   ```sh
   docker --version
   terraform --version
   tmux -V
   ```

### 3.3. Troubleshooting

Common issues and solutions:

- SSH Connection Issues
  - Check security list rules
  - Verify SSH key permissions
  - Confirm instance state
- AWS Configuration Problems
  - Validate credentials
  - Check region settings
- Resource Limits
  - Verify Always Free tier usage
  - Check compute shape availability

### 3.4. Maintenance

Regular maintenance tasks:

```sh
# Update system packages
./update-system.sh

# Backup Terraform state
./backup-tfstate.sh

# Monitor resource usage
./check-usage.sh
```

### 3.5. Cleanup

Remove all resources:

```sh
# Destroy infrastructure
terraform destroy

# Clean local files
./cleanup.sh
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 4. Roadmap

- [ ] Add terraform state backend configuration
- [ ] Implement automated backups
- [ ] Add monitoring and alerting
- [ ] Support additional development tools
- [ ] Enhance mobile shell configuration

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 5. Contributing

Contributions are welcome! Here's how you can help:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 6. License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 7. Contact

Jonathan Nguyen - jonathan@jdnguyen.tech

Project Link: [https://github.com/jonathan-d-nguyen/dev_bootstrap](https://github.com/jonathan-d-nguyen/dev_bootstrap)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 8. Acknowledgments

- [Oracle Cloud Always Free Tier](https://www.oracle.com/cloud/free/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS CLI Documentation](https://aws.amazon.com/cli/)
- [Best-README-Template](https://github.com/othneildrew/Best-README-Template)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->

[contributors-shield]: https://img.shields.io/github/contributors/jonathan-d-nguyen/dev_bootstrap.svg?style=for-the-badge
[contributors-url]: https://github.com/jonathan-d-nguyen/dev_bootstrap/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/jonathan-d-nguyen/dev_bootstrap.svg?style=for-the-badge
[forks-url]: https://github.com/jonathan-d-nguyen/dev_bootstrap/network/members
[stars-shield]: https://img.shields.io/github/stars/jonathan-d-nguyen/dev_bootstrap.svg?style=for-the-badge
[stars-url]: https://github.com/jonathan-d-nguyen/dev_bootstrap/stargazers
[issues-shield]: https://img.shields.io/github/issues/jonathan-d-nguyen/dev_bootstrap.svg?style=for-the-badge
[issues-url]: https://github.com/jonathan-d-nguyen/dev_bootstrap/issues
[license-shield]: https://img.shields.io/github/license/jonathan-d-nguyen/dev_bootstrap.svg?style=for-the-badge
[license-url]: https://github.com/jonathan-d-nguyen/dev_bootstrap/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/your-username
[Terraform.io]: https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white
[Terraform-url]: https://www.terraform.io/
[Docker.io]: https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white
[Docker-url]: https://www.docker.com/
[Shell.io]: https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white
[Shell-url]: https://www.gnu.org/software/bash/
[OCI.io]: https://img.shields.io/badge/Oracle_Cloud-%23F80000.svg?style=for-the-badge&logo=oracle&logoColor=white
[OCI-url]: https://www.oracle.com/cloud/
[AWS.io]: https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white
[AWS-url]: https://aws.amazon.com/
