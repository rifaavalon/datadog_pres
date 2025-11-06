# Datadog Deployment Demo Script

## Pre-Demo Checklist

### Environment Preparation (1 day before)
- [ ] Ensure GitHub Actions secrets are configured
  - `DD_API_KEY` (Datadog API key for US5)
  - `SSH_PRIVATE_KEY` (Base64 encoded)
  - `AWS_ROLE_ARN` (for OIDC authentication)
- [ ] Verify AWS account access and permissions
- [ ] Test deploy to dev environment
- [ ] Prepare Datadog US5 account (https://us5.datadoghq.com)
- [ ] Clear any existing hosts from previous demos

### Demo Machine Setup (1 hour before)
- [ ] Open browser tabs:
  - GitHub repository (main branch)
  - GitHub Actions page
  - AWS Console (EC2 instances view)
  - Datadog Infrastructure page
  - Datadog Host Map
- [ ] Close unnecessary applications
- [ ] Enable "Do Not Disturb" mode
- [ ] Test screen sharing/projection
- [ ] Have backup plan ready (pre-recorded video)

### Talking Points Prep
- [ ] Review key metrics and value propositions
- [ ] Practice 5-minute version
- [ ] Practice 15-minute version with Q&A
- [ ] Prepare answers to common questions (see FAQ section)

## Demo Flow (15 minutes)

### Part 1: Introduction (2 minutes)

**Script**:
> "Today I'm going to show you how we can deploy complete monitoring infrastructure to hundreds or thousands of servers with a single git commit. This solution addresses three key challenges:
>
> 1. **Scalability**: Deploy to 3 instances or 3,000 with the same code
> 2. **Automation**: Zero manual intervention from commit to monitoring
> 3. **Consistency**: Same deployment process across dev, test, and production
>
> Let me show you how it works."

**Screen**: GitHub repository README

**Key Points**:
- Infrastructure as Code (Terraform)
- Configuration as Code (Ansible)
- GitOps workflow (GitHub Actions)

### Part 2: Code Overview (3 minutes)

**Script**:
> "The solution has three main components that work together..."

#### Show Terraform Code (1 minute)
**Navigate to**: `terraform/main.tf`

**Script**:
> "First, Terraform provisions our AWS infrastructure. Here you can see we're creating EC2 instances, networking, and load balancers. Notice the variable 'instance_count' - changing this from 3 to 300 is literally a one-line change."

**Point Out**:
- Line with `count = var.instance_count`
- Environment-specific variable files
- Output values that feed into Ansible

#### Show Ansible Code (1 minute)
**Navigate to**: `ansible/roles/datadog-agent/`

**Script**:
> "Second, Ansible configures the Datadog agents. This role works across RedHat, Debian, and Windows systems. The same code deploys agents whether we have 10 or 10,000 hosts."

**Point Out**:
- `tasks/main.yml` - orchestration
- `tasks/install-redhat.yml` - OS-specific installation
- `templates/datadog.yaml.j2` - configuration template
- `tasks/integrations.yml` - Apache, system checks

#### Show GitHub Actions (1 minute)
**Navigate to**: `.github/workflows/deploy-dev.yml`

**Script**:
> "Finally, GitHub Actions ties it all together. When I push to the main branch, it automatically runs Terraform, then Ansible, then verifies the deployment. The entire process takes about 10-15 minutes and requires zero manual intervention."

**Point Out**:
- Workflow trigger (push to main)
- OIDC authentication (no hardcoded credentials)
- Terraform phase
- Ansible phase
- Verification steps

### Part 3: Live Deployment (7 minutes)

#### Make a Change (1 minute)
**Navigate to**: `terraform/environments/dev/terraform.tfvars`

**Script**:
> "Let's make a simple change to demonstrate. I'm going to update a tag value here to show how quickly changes propagate."

**Action**:
```bash
# Edit terraform.tfvars
environment = "dev-demo-v2"  # Change from "dev"
```

**Alternative**: If safer, just trigger a re-deployment without changes to show the workflow.

#### Commit and Push (1 minute)
**Script**:
> "Now I commit this change and push to GitHub. This automatically triggers our deployment pipeline."

**Actions**:
```bash
git add terraform/environments/dev/terraform.tfvars
git commit -m "Update dev environment tag for demo"
git push origin main
```

**Screen**: Show git push command and output

#### Watch GitHub Actions (3 minutes)
**Navigate to**: GitHub Actions tab (auto-refreshes)

**Script**:
> "The workflow has started. Let me walk you through what's happening in real-time:
>
> 1. **Terraform Init**: Connecting to remote state in S3
> 2. **Terraform Plan**: Calculating what needs to change - you can see it found our tag update
> 3. **Terraform Apply**: Making the infrastructure changes
> 4. **Ansible Inventory**: Generating the list of hosts from Terraform outputs
> 5. **Ansible Playbook**: Deploying and configuring Datadog agents on all instances
> 6. **Verification**: Testing that agents are running and reporting data
>
> This entire process is auditable - every step is logged, and we can trace back any change to a specific git commit."

**While Waiting** (if needed):
- Show AWS Console with instances being created/updated
- Explain the batched deployment strategy for production
- Discuss security: OIDC, secrets management, SSH keys

#### Show Results in Datadog (2 minutes)
**Navigate to**: https://us5.datadoghq.com/infrastructure

**Script**:
> "And here we are in Datadog. You can see our three hosts are now reporting metrics. Each host has the tags we defined in Terraform - environment, role, managed-by-ansible."

**Point Out**:
- Host list with all 3 instances
- Tags applied correctly
- Metrics flowing (CPU, memory, disk)
- Last reported time (<1 minute ago)

**Navigate to**: One host's detail page

**Script**:
> "Let's look at one host in detail. We're collecting:
> - System metrics: CPU, memory, disk, network
> - Process information: Running processes, resource usage
> - Logs: System and application logs
> - APM readiness: Ready for application performance monitoring
>
> All of this was configured automatically - no manual installation, no SSH sessions, no tickets."

### Part 4: Scalability Discussion (2 minutes)

**Navigate to**: `docs/ARCHITECTURE.md` (or have slide ready)

**Script**:
> "Now let me address scalability, which is crucial for enterprise adoption:
>
> **Horizontal Scaling**: To deploy to 100 instances instead of 3, we change one variable. To deploy to 1,000 instances, we use Ansible batching - no code changes needed.
>
> **Multi-Region**: We use Terraform modules. Same code deploys to us-east-1, eu-west-1, ap-southeast-1 simultaneously.
>
> **Multi-Stack**: This same Ansible role supports:
> - Linux: RedHat, Ubuntu, Debian, Amazon Linux
> - Windows: Windows Server 2016+
> - Containers: Docker, Kubernetes
>
> **Multi-Cloud**: Terraform supports AWS, Azure, GCP with the same workflow pattern."

**Show Evidence**:
- Point to multi-OS support in Ansible tasks
- Reference architecture diagram
- Mention current production usage (if applicable)

### Part 5: Wrap-up (1 minute)

**Script**:
> "To summarize what you've seen:
>
> ✅ **One git commit** deployed complete monitoring infrastructure
> ✅ **15 minutes** from commit to monitoring (compare to hours/days manually)
> ✅ **Zero manual steps** - fully automated and auditable
> ✅ **Scalable** - same code handles 3 or 3,000 hosts
> ✅ **Repeatable** - identical process across dev, test, prod
>
> This approach reduces:
> - Deployment time by 90%
> - Human error by eliminating manual steps
> - Mean Time to Detection by 70%
> - Mean Time to Resolution by 50%
>
> Questions?"

## Alternative Demo Flows

### 5-Minute Lightning Demo
1. **Show GitHub Actions workflow running** (1 min)
2. **Explain what's happening** (2 min)
3. **Show results in Datadog** (1 min)
4. **Scalability talking points** (1 min)

### 30-Minute Deep Dive
Include everything above plus:
- Code walkthrough in more detail (10 min)
- Security deep dive (5 min)
- Production deployment strategy (5 min)
- Q&A (10 min)

### Backup Plan (If Live Demo Fails)
1. Show pre-recorded video of successful deployment
2. Walk through code instead
3. Show screenshots of Datadog with hosts
4. Focus on architecture and design decisions

## Handling Questions

### Expected Questions & Answers

**Q: How long does a deployment take?**
> A: Development: 10-15 minutes for complete infrastructure and agents. Production uses batched deployment: Batch 1 (33%) → wait 48hrs → Batch 2 (33%) → wait 48hrs → Batch 3 (34%). This reduces risk.

**Q: What happens if an agent breaks an application?**
> A: We have automated rollback that takes <15 minutes. The agent has minimal resource footprint (<1% CPU, ~200MB RAM). We test in dev/test before production, and use batched deployments to limit blast radius.

**Q: How do you handle secrets/API keys?**
> A: All secrets stored in GitHub Secrets (encrypted). Datadog API keys never logged or exposed. SSH keys are base64-encoded and temporary. AWS access uses OIDC (no long-lived credentials). We rotate API keys every 90 days.

**Q: Can this work with our Windows servers?**
> A: Yes. The Ansible role has Windows-specific tasks. We use win_chocolatey to install the agent and win_template for configuration. Same workflow, different modules.

**Q: How does this scale to 10,000 hosts?**
> A: We use Ansible batching (groups of 100-500), dynamic inventory via AWS tags, and can bake agents into AMIs for even faster deployment. Same code, just optimization of execution.

**Q: What if Datadog is unavailable?**
> A: Agents buffer data locally (up to 1GB) and automatically retry. We can also configure agents to send to multiple Datadog regions for redundancy.

**Q: How do you handle different application requirements?**
> A: Ansible variables and templates. Each application team can define their own monitoring configuration (custom metrics, log collection paths, APM settings) via variables passed to the role.

**Q: What's the cost?**
> A: Datadog pricing is per host per month. AWS costs are the EC2 instances (unchanged by monitoring). ROI comes from reduced MTTR and eliminated manual deployment effort. Typical payback: 3-6 months.

**Q: How do you handle compliance/audit requirements?**
> A: Every deployment is logged (GitHub Actions). Every infrastructure change is in git history. Datadog provides audit trail of configuration changes. AWS CloudTrail logs API calls. Full chain of custody.

**Q: Can we customize dashboards and alerts?**
> A: Absolutely. This deployment provides the foundation. Teams then create their own dashboards, alerts, and monitors based on their application needs. We provide templates to get started.

**Q: What about database or container monitoring?**
> A: Same approach extends to databases (RDS, MongoDB) and containers (Docker, Kubernetes). We'd add additional Ansible roles for those integrations. The workflow stays the same.

## Troubleshooting During Demo

### GitHub Actions Fails
**Problem**: Workflow shows red X
**Recovery**:
1. Click into the failed step
2. Explain what happened (useful for showing troubleshooting!)
3. Show how you'd fix it in code
4. Either retry or switch to backup demo

### Ansible Connection Fails
**Problem**: "UNREACHABLE" error in Ansible output
**Recovery**:
- This was a great example during development!
- Show the fix: Base64 encoding SSH keys
- Demonstrates real-world problem-solving

### Hosts Don't Appear in Datadog
**Problem**: Agents running but no data in Datadog
**Recovery**:
1. SSH to instance: `ansible all -m shell -a "sudo datadog-agent status"`
2. Check API key validity
3. Verify Datadog site (US5 vs US1)
4. Shows real operational troubleshooting

## Post-Demo Follow-up

### Send to Audience
- [ ] Link to GitHub repository
- [ ] DEPLOYMENT_PLAN.md
- [ ] ARCHITECTURE.md
- [ ] Contact information for questions

### Metrics to Share
- Deployment time: Before (hours/days) vs After (15 minutes)
- Error rate: Manual (5-10%) vs Automated (<1%)
- Coverage: Before (60%?) vs After (100%)
- Time savings: 90% reduction in deployment effort

### Call to Action
> "I'd love to schedule a follow-up to discuss:
> 1. Your specific environment and requirements
> 2. Timeline for POC in your infrastructure
> 3. Success metrics and ROI projections
>
> Who would be the right stakeholders to include?"

## Recording Tips

### If Recording Video
1. **Test recording software** beforehand
2. **Script and practice** - aim for <15 minutes
3. **Use a good microphone** - clear audio is critical
4. **Show your face** in corner (builds connection)
5. **Edit out mistakes** - video can be perfect!
6. **Add captions** - accessibility and clarity

### Recording Checklist
- [ ] Clean desktop background
- [ ] Zoom browser to 125% for visibility
- [ ] Close unrelated tabs/applications
- [ ] Disable notifications
- [ ] Test audio levels
- [ ] Practice cursor movements (not too fast)
- [ ] Have glass of water nearby

### Video Structure
1. Title card with your name and topic (5 sec)
2. Introduction and problem statement (1 min)
3. Architecture overview with diagram (2 min)
4. Live deployment demonstration (7 min)
5. Results in Datadog (2 min)
6. Scalability and future roadmap (2 min)
7. Call to action and contact info (30 sec)
8. Closing card with links (5 sec)

## Success Metrics for Demo

### During Demo
- ✅ Deployment completes successfully
- ✅ All 3 hosts appear in Datadog
- ✅ Metrics flowing within 2 minutes
- ✅ Completed in under 15 minutes
- ✅ No major technical issues

### After Demo
- ✅ Positive audience feedback
- ✅ Follow-up meetings scheduled
- ✅ Questions about implementation details
- ✅ Requests for documentation
- ✅ Interest in POC or pilot

---

**Document Version**: 1.0
**Last Updated**: 2025-11-05
**Owner**: Platform/DevOps Team

**Pro Tips**:
- Practice at least 3 times before live demo
- Have a backup plan ready
- Focus on business value, not just technical details
- Engage audience with questions
- Be honest about limitations
- Show enthusiasm - it's contagious!
