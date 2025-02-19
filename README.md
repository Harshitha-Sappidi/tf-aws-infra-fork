# Terraform AWS Networking Setup


## Prerequisites
Before using this Terraform setup, ensure you have:
- An AWS account
- AWS CLI installed and configured (`aws configure`)
- Terraform installed (`terraform -v`)
- GitHub Actions enabled for CI/CD

## AWS Networking Setup
The following infrastructure is provisioned using Terraform:

1. **Virtual Private Cloud (VPC)**: Creates an isolated network in AWS.
2. **Subnets**:
   - 3 public subnets
   - 3 private subnets  
   Each subnet is in a different availability zone.
3. **Internet Gateway**: Enables internet access for public subnets.
4. **Public Route Table**: Routes internet traffic through the Internet Gateway.
5. **Private Route Table**: Routes internal traffic securely.
6. **Public Route**: Configured to allow internet access (`0.0.0.0/0`).

## Terraform Setup and Deployment
### Step 1: Install Dependencies
Ensure Terraform and AWS CLI are installed. Configure AWS credentials:

   `aws configure for dev and demo account`

### Step 2: Initialize Terraform

`terraform init`

### Step 3: Format and Validate Configuration

`terraform fmt`

`terraform validate`

### Step 4: Plan Deployment
Preview the resources that will be created:

`terraform plan`

### Step 5: Apply Deployment
Deploy the infrastructure:

`terraform apply` 

### Step 6: Destroy Infrastructure (Optional)
To remove all created resources:

`terraform destroy`

## CI Workflow

The GitHub Actions workflow is defined in .github/workflows/terraform.yml.

To enforce branch protection, enable Status Checks on GitHub.

### Folder Structure

```plaintext
TF-AWS-INFRA-FORK/
│
├── .github/workflows/terraform.yml       # GitHub Actions workflow for CI
├── .gitignore                            # Gitignore
├── provider.tf                           # Defines AWS provider configuration
├── vpc.tf                                # Configures VPC
├── subnet.tf                             # Defines subnets
├── routetable.tf                         # Configures route tables
├── internetgateway.tf                    # Creates an Internet Gateway
├── variable.tf                           # Stores input variables
├── terraform.tfstate                     # Terraform state file (after deployment)
├── terraform.tfvars                      # Variable values (should be kept private)
├── version.tf                            # Stores the version
