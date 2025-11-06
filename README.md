# Datadog Agent Deployment - Technical Presentation

## Overview

This repository contains a complete demonstration of deploying the Datadog monitoring agent across multiple environments using Infrastructure as Code (IaC) and configuration management tools. The solution showcases deployment automation, project management, and scalable architecture design.


## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Demo Walkthrough](#demo-walkthrough)
- [Project Management](#project-management)
- [Deployment Strategy](#deployment-strategy)
- [Scaling](#scaling)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)

## 🚀 Quick Start

### 1. Setup Your Environment

```bash
# Clone or navigate to this repository
cd datadog_pres

# Run the setup script
./scripts/setup-demo.sh
```

This will:
- Check prerequisites (Terraform, Ansible, AWS CLI)
- Validate AWS credentials
- Configure Datadog API key
- Create SSH keys
- Initialize Terraform
- Set up demo aliases

### 2. Deploy to Development

```bash
# Deploy infrastructure and Datadog agents to Dev
./scripts/deploy-environment.sh dev
```

### 3. View Results

```bash
# Check agent status
cd ansible
ansible all -i inventory/dev.ini -m shell -a "datadog-agent status" --become

# View in Datadog UI
# Navigate to: https://app.datadoghq.com/infrastructure
```

### 4. Cleanup

```bash
# Destroy all resources
./scripts/cleanup.sh dev
```

## ✅ GitHub Actions - Fully Functional!

The GitHub Actions workflows are **ready to use**! They include:

- ✅ Automated dev deployments on push to main
- ✅ Approval-gated test deployments
- ✅ Batched production deployments (30% / 40% / 30%)
- ✅ Dynamic inventory generation
- ✅ Full CI/CD automation

**Quick Setup (5 minutes):**
```bash
./scripts/setup-github-actions.sh
```

**Then configure GitHub Secrets and Environments.** See [docs/GITHUB_ACTIONS_SETUP.md](docs/GITHUB_ACTIONS_SETUP.md) for complete instructions.

**For demo presentations:** You can still run locally using `./scripts/deploy-environment.sh` for better visibility.

## 🏗️ Architecture

### High-Level Design

```
┌─────────────────┐
│  GitHub Repo    │
│  (Source Code)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ GitHub Actions  │
│   (CI/CD)       │
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌─────────┐ ┌─────────┐
│Terraform│ │ Ansible │
│  (IaC)  │ │ (Config)│
└────┬────┘ └────┬────┘
     │           │
     ▼           ▼
┌─────────────────────────┐
│   AWS Infrastructure    │
│  ┌─────────────────┐    │
│  │ Dev (3 inst)    │    │
│  │ Test (5 inst)   │    │
│  │ Prod (10 inst)  │    │
│  └─────────────────┘    │
└───────────┬─────────────┘
            │
            ▼
     ┌──────────────┐
     │   Datadog    │
     │   Platform   │
     └──────────────┘
```

### Key Components

| Component | Purpose | Technology |
|-----------|---------|------------|
| **Infrastructure** | Provision cloud resources | Terraform |
| **Configuration** | Deploy and configure agents | Ansible |
| **CI/CD** | Automate deployments | GitHub Actions |
| **Monitoring** | Collect metrics, logs, traces | Datadog |

For detailed architecture diagrams, see [diagrams/architecture.md](diagrams/architecture.md)

## 📁 Project Structure

```
datadog_pres/
├── README.md                          # This file
├── .github/
│   └── workflows/                     # CI/CD pipelines
│       ├── deploy-dev.yml            # Auto-deploy to dev
│       ├── deploy-test.yml           # Approval-gated test deploy
│       └── deploy-prod.yml           # Production deployment
├── terraform/                         # Infrastructure as Code
│   ├── main.tf                       # Root module
│   ├── variables.tf                  # Variable definitions
│   ├── outputs.tf                    # Output values
│   ├── modules/                      # Reusable modules
│   │   ├── vpc/                      # VPC networking
│   │   ├── compute/                  # EC2 instances
│   │   └── alb/                      # Load balancer
│   └── environments/                 # Environment configs
│       ├── dev/terraform.tfvars      # Dev variables
│       ├── test/terraform.tfvars     # Test variables
│       └── prod/terraform.tfvars     # Prod variables
├── ansible/                          # Configuration Management
│   ├── ansible.cfg                   # Ansible configuration
│   ├── inventory/                    # Target hosts
│   │   ├── dev.ini
│   │   ├── test.ini
│   │   └── prod.ini
│   ├── playbooks/                    # Orchestration playbooks
│   │   └── deploy-datadog.yml
│   └── roles/                        # Reusable roles
│       └── datadog-agent/
│           ├── tasks/                # Installation tasks
│           ├── templates/            # Config templates
│           ├── defaults/             # Default variables
│           └── handlers/             # Service handlers
├── scripts/                          # Helper scripts
│   ├── setup-demo.sh                # Environment setup
│   ├── deploy-environment.sh        # Deploy automation
│   └── cleanup.sh                   # Teardown script
├── docs/                             # Documentation
│   ├── project-plan.md              # Full project plan
│   └── presentation-script.md       # Presentation guide
└── diagrams/                         # Architecture diagrams
    └── architecture.md              # Mermaid diagrams
```

## ✅ Prerequisites

### Required Software

| Tool | Version | Purpose | Installation |
|------|---------|---------|--------------|
| **Terraform** | >= 1.0 | Infrastructure provisioning | [terraform.io](https://www.terraform.io/downloads) |
| **Ansible** | >= 2.10 | Configuration management | `pip install ansible` |
| **AWS CLI** | >= 2.0 | AWS interaction | [aws.amazon.com/cli](https://aws.amazon.com/cli/) |
| **Python** | >= 3.8 | Ansible runtime | [python.org](https://www.python.org/downloads/) |
| **Git** | >= 2.0 | Version control | [git-scm.com](https://git-scm.com/) |

### Required Accounts

1. **AWS Account** with permissions to create:
   - VPC, Subnets, Route Tables
   - EC2 instances
   - Security Groups
   - Load Balancers
   - IAM roles

2. **Datadog Account** with:
   - API key
   - Application key (for advanced features)
   - Trial account works: [datadoghq.com/free-trial](https://www.datadoghq.com/free-trial/)





