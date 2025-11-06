# Datadog Deployment Architecture

## Overview

This document describes the architecture of the automated Datadog agent deployment solution. The architecture is designed for scalability, security, and operational efficiency across multiple environments.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          GitHub Repository                               │
│  ┌─────────────────┐  ┌──────────────────┐  ┌──────────────────────┐  │
│  │  Terraform IaC  │  │  Ansible Roles   │  │  GitHub Actions      │  │
│  │  - main.tf      │  │  - datadog-agent │  │  - deploy-dev.yml    │  │
│  │  - variables.tf │  │  - templates     │  │  - deploy-test.yml   │  │
│  │  - outputs.tf   │  │  - tasks         │  │  - deploy-prod.yml   │  │
│  └─────────────────┘  └──────────────────┘  └──────────────────────┘  │
└──────────────────┬──────────────────────────────────────────────────────┘
                   │
                   │ git push (triggers)
                   ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        GitHub Actions Runner                             │
│  ┌───────────────────────────────────────────────────────────────────┐ │
│  │  Workflow Execution                                               │ │
│  │  1. Checkout code                                                 │ │
│  │  2. Configure AWS credentials (OIDC)                              │ │
│  │  3. Run Terraform (init → plan → apply)                           │ │
│  │  4. Generate dynamic Ansible inventory                            │ │
│  │  5. Run Ansible playbook                                          │ │
│  │  6. Verify deployment                                             │ │
│  └───────────────────────────────────────────────────────────────────┘ │
└──────────────┬──────────────────────────────────────────────────────────┘
               │
               │ OIDC Auth
               ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                           AWS Account                                    │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    Terraform Deployment                         │   │
│  │  - VPC, Subnets, Security Groups                                │   │
│  │  - EC2 Instances (with tags)                                    │   │
│  │  - Application Load Balancer                                    │   │
│  │  - IAM Roles and Policies                                       │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                           │
│                              │ Infrastructure Created                    │
│                              ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                   Environment: DEV / TEST / PROD                │   │
│  │  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐     │   │
│  │  │ EC2 Instance │    │ EC2 Instance │    │ EC2 Instance │     │   │
│  │  │  - httpd     │    │  - httpd     │    │  - httpd     │     │   │
│  │  │  - dd-agent  │    │  - dd-agent  │    │  - dd-agent  │     │   │
│  │  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘     │   │
│  │         │                   │                    │              │   │
│  └─────────┼───────────────────┼────────────────────┼──────────────┘   │
│            │                   │                    │                   │
└────────────┼───────────────────┼────────────────────┼───────────────────┘
             │                   │                    │
             │ Ansible SSH       │ Ansible SSH        │ Ansible SSH
             │ (Agent Deploy)    │ (Agent Deploy)     │ (Agent Deploy)
             │                   │                    │
             └───────────────────┴────────────────────┘
                                 │
                                 │ Metrics, Logs, Traces
                                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         Datadog Platform (US5)                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────┐    │
│  │  Infrastructure │  │  APM & Traces   │  │  Logs Management    │    │
│  │  Monitoring     │  │                 │  │                     │    │
│  └─────────────────┘  └─────────────────┘  └─────────────────────┘    │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────┐    │
│  │  Dashboards     │  │  Alerts         │  │  Process Monitoring │    │
│  └─────────────────┘  └─────────────────┘  └─────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────┘
```

## Component Details

### 1. Source Control (GitHub)

**Purpose**: Single source of truth for infrastructure and configuration code

**Components**:
- **Terraform Code**: Defines AWS infrastructure
  - VPC, subnets, security groups
  - EC2 instances with proper tagging
  - Load balancers and networking

- **Ansible Roles**: Configuration management
  - `datadog-agent` role for agent deployment
  - OS-specific installation tasks (RedHat, Debian, Windows)
  - Configuration templates
  - Integration configurations

- **GitHub Actions Workflows**: CI/CD automation
  - Environment-specific workflows (dev, test, prod)
  - OIDC authentication to AWS
  - Orchestration of Terraform and Ansible

**Key Features**:
- Branch protection on main
- Pull request reviews required
- Automated testing before merge
- Secrets management via GitHub Secrets

### 2. GitHub Actions (CI/CD)

**Purpose**: Automated deployment orchestration

**Workflow Steps**:
1. **Trigger**: Push to main branch or manual dispatch
2. **Authentication**: OIDC connection to AWS (no long-lived credentials)
3. **Terraform Phase**:
   - Initialize with remote state (S3 + DynamoDB)
   - Plan infrastructure changes
   - Apply changes with auto-approval
   - Output instance IPs and metadata
4. **Ansible Phase**:
   - Generate dynamic inventory from Terraform outputs
   - Configure SSH access with base64-encoded keys
   - Deploy Datadog agents to all instances
   - Configure integrations (Apache, system checks)
5. **Verification**:
   - Test Ansible connectivity
   - Check agent status
   - Verify metrics flowing to Datadog

**Security Features**:
- No hardcoded credentials
- SSH keys stored as GitHub Secrets (base64 encoded)
- Datadog API keys stored as secrets
- OIDC for temporary AWS credentials
- Audit trail of all deployments

### 3. AWS Infrastructure

**Purpose**: Compute and networking infrastructure for applications

**Components**:

**VPC Architecture**:
- 3 public subnets across 3 availability zones
- Internet Gateway for outbound connectivity
- Security groups with least-privilege access
- Network ACLs for defense in depth

**Compute**:
- EC2 instances (Amazon Linux 2)
- Instance profiles with minimal IAM permissions
- Auto-scaling groups (production only)
- Application Load Balancer for traffic distribution

**Tagging Strategy**:
```
Environment: dev | test | prod
ManagedBy: terraform
Project: datadog-demo
Role: webserver
```

**Multi-Environment Strategy**:
- Separate VPCs per environment
- Terraform workspaces for state isolation
- Environment-specific variable files

### 4. Datadog Agents

**Purpose**: Collect and forward observability data to Datadog

**Agent Configuration**:
```yaml
api_key: <from-github-secret>
site: us5.datadoghq.com
hostname: <ec2-instance-hostname>
tags:
  - env:<environment>
  - role:webserver
  - managed:ansible

# Features enabled
apm_config:
  enabled: true
  apm_non_local_traffic: true

logs_enabled: true
process_config:
  enabled: true
```

**Integrations**:
- **System**: CPU, memory, disk, network metrics
- **Apache**: Web server metrics and logs
- **Process**: Process-level monitoring
- **Logs**: Application and system logs

**Data Flow**:
1. Agent collects metrics every 15 seconds
2. Logs streamed in real-time
3. APM traces sent immediately
4. Data compressed and sent via HTTPS to US5
5. Local buffering if connectivity lost

### 5. Datadog Platform

**Purpose**: Centralized observability platform

**Features Used**:
- **Infrastructure Monitoring**: Host-level metrics and health
- **APM**: Application performance tracing
- **Log Management**: Centralized log aggregation
- **Dashboards**: Custom visualizations
- **Alerts**: Proactive incident detection

**Data Retention**:
- Metrics: 15 months
- Logs: 15 days (configurable)
- Traces: 15 days

## Data Flow

### 1. Deployment Flow
```
Developer → Git Push → GitHub Actions → Terraform → AWS Infrastructure
                                    ↓
                             Ansible → Configure Agents → Start Agents
```

### 2. Monitoring Data Flow
```
Application → Datadog Agent → HTTPS (compressed) → Datadog US5 Platform
                ↓
         Local Buffer (if offline)
```

### 3. Alert Flow
```
Datadog Platform → Evaluate Alert Rules → Trigger Alert → Notify (Slack/PagerDuty/Email)
```

## Scalability Design

### Horizontal Scalability

**Current State**: 3 instances per environment (9 total)

**Scaling to 100 instances**:
- Update Terraform variable: `instance_count = 100`
- Ansible handles all instances automatically
- No code changes required

**Scaling to 1000 instances**:
- Use AWS Auto Scaling Groups
- Implement dynamic inventory via AWS tags
- Agent installation via user-data or AMI baking
- Batched Ansible runs (groups of 100)

**Scaling to Multiple Regions**:
```hcl
# Terraform module structure
module "datadog_us_east_1" {
  source = "./modules/datadog-infrastructure"
  region = "us-east-1"
}

module "datadog_eu_west_1" {
  source = "./modules/datadog-infrastructure"
  region = "eu-west-1"
}
```

### Vertical Scalability

**Agent Resource Usage** (per host):
- CPU: <1%
- Memory: ~200MB
- Network: ~1KB/s steady state

**Optimizations for Large Scale**:
- Reduce check intervals for non-critical metrics
- Sample logs instead of full collection
- Use log exclusion filters
- APM sampling for high-traffic services

### Multi-Stack Support

**Current**: Amazon Linux 2 with Apache

**Supported Platforms**:
- **Linux**: RedHat, CentOS, Ubuntu, Debian, Amazon Linux
- **Windows**: Windows Server 2016+
- **Containers**: Docker, Kubernetes
- **Cloud**: AWS, Azure, GCP

**Example Multi-Stack**:
```yaml
# Ansible inventory
[webservers]
web1 ansible_os_family=RedHat
web2 ansible_os_family=Debian

[appservers]
app1 ansible_os_family=Windows

[containers]
k8s-cluster ansible_platform=kubernetes
```

## Security Architecture

### Secret Management

**API Keys**:
- Stored in GitHub Secrets (encrypted at rest)
- Never logged or exposed in outputs
- Rotation policy: every 90 days

**SSH Keys**:
- Base64 encoded in GitHub Secrets
- Temporary (created per deployment)
- Restricted to specific security groups

**AWS Credentials**:
- OIDC federation (no long-lived keys)
- Session duration: 1 hour
- Least-privilege IAM roles

### Network Security

**Inbound**:
- SSH: Restricted to GitHub Actions IPs
- HTTP/HTTPS: Load balancer only
- Datadog Agent: Outbound only (no inbound)

**Outbound**:
- Datadog endpoints: `*.datadoghq.com:443`
- Package repos: `yum.datadoghq.com:443`

### Compliance

**Audit Trail**:
- GitHub: All code changes tracked
- GitHub Actions: All deployments logged
- AWS CloudTrail: All API calls logged
- Datadog: Agent status and configuration changes

**Data Privacy**:
- Log scrubbing for sensitive data (PII, credentials)
- Encryption in transit (TLS 1.2+)
- Encryption at rest (Datadog managed)

## High Availability

### Infrastructure HA
- Multi-AZ deployment (3 availability zones)
- Application Load Balancer with health checks
- Auto-scaling groups (production)

### Agent HA
- Local buffering (up to 1GB)
- Automatic reconnection on network failure
- Health checks and auto-restart

### Deployment HA
- Blue/green deployment capability
- Rollback automation
- Batch deployment strategy reduces blast radius

## Disaster Recovery

### Backup Strategy
- Terraform state: S3 with versioning enabled
- Configuration: Git version control
- Datadog dashboards: Terraform or API export

### Recovery Time Objectives (RTO)
- Complete environment rebuild: <30 minutes
- Agent redeployment: <15 minutes
- Configuration rollback: <5 minutes

### Recovery Point Objectives (RPO)
- Infrastructure state: Real-time (Terraform state)
- Configuration: Real-time (Git commits)
- Monitoring data: N/A (real-time streaming)

## Monitoring the Monitoring

**Agent Health Monitoring**:
- Datadog monitors for agent status
- Alert if agent stops reporting
- Dashboard showing agent version distribution

**Deployment Health**:
- GitHub Actions success/failure alerts
- Terraform plan review before apply
- Ansible task failure notifications

**Cost Monitoring**:
- AWS Cost Explorer tags
- Datadog billing dashboard
- Monthly cost reports

## Future Enhancements

### Short Term (1-3 months)
- [ ] Add Windows Server support
- [ ] Implement container monitoring (Docker)
- [ ] Create self-service onboarding portal
- [ ] Automated agent updates

### Medium Term (3-6 months)
- [ ] Kubernetes integration
- [ ] Multi-cloud support (Azure, GCP)
- [ ] Custom metrics collection
- [ ] SLO tracking and reporting

### Long Term (6-12 months)
- [ ] AI-powered anomaly detection
- [ ] Auto-remediation for common issues
- [ ] Cost optimization automation
- [ ] Service mesh integration

## Appendix

### A. Network Diagram
See deployed VPC architecture for network topology details.

### B. Decision Records
- Why Ansible over Chef/Puppet: Agentless, simpler for this use case
- Why GitHub Actions over Jenkins: Native GitHub integration, OIDC support
- Why Terraform over CloudFormation: Multi-cloud capability, better module ecosystem
- Why Datadog US5: New account default, no migration required

### C. Performance Benchmarks
- Deployment time: 10-15 minutes for full environment
- Agent installation: <2 minutes per host
- Time to first metric: <1 minute after agent start

---

**Document Version**: 1.0
**Last Updated**: 2025-11-05
**Owner**: Platform/DevOps Team
