# terraform-latest
 
1. Initialize Terraform
 terraform init
2. Validate configuration
 terraform validate
3. Format Terraform files
 terraform fmt
4. Preview changes
 terraform plan
5. Apply changes
 terraform apply
 terraform apply -auto-approve
6. Destroy infrastructure
 terraform destroy
 terraform destroy -auto-approve
7. Inspect state
 terraform show
 terraform state list
 terraform state show <resource>
8. Import existing resources
 terraform import <resource> <id>
--------------------------------------------------------------------------------------------------------------------
Why main.tf and variables.tf are used
Terraform configuration is usually split into multiple files for readability and separation of concerns. 

**Two common files are main.tf and variables.tf.**
--------------------------------------------------------------------------------------------------------------------
main.tf — purpose and details
Primary configuration: main.tf typically contains the provider block, resource definitions, data sources, and
outputs. It is the file (or set of files) that declare what infrastructure you want Terraform to create or manage.


main.tf: Holds main configuration: providers + resources.
variables.tf: Declares input variables for reusability and clarity.
------------------------------------------------------------------------------------------------
Backend file

bucket = "my-terraform-state-bucket"
key    = "vpcs/example-vpc/terraform.tfstate"
region = "us-east-2"
encrypt = true
dynamodb_table = "terraform-locks"
workspace_key_prefix = "dev-workspaces"


bucket: S3 bucket name where Terraform state is stored.
key: File path inside the bucket for the state file.
region: AWS region where the backend bucket/table lives.
encrypt: Ensures state is encrypted at rest in S3.
dynamodb_table: Used for state locking to prevent concurrent changes.
workspace_key_prefix: Prefix in S3 to separate states per workspace.

------------------------------------------------------------------------------------------------
terraform init: Initializes providers and backend.
terraform validate: Checks config syntax and schema.
terraform plan: Previews what Terraform will create, update, or destroy.
terraform apply: Executes the changes from the plan.
terraform destroy: Deletes resources defined in the configuration.
Why remote state (S3+DynamoDB): Enables collaboration, locking, versioning, and secure
centralized state.


------------------------------------------------------------------------------------------------

1. What is a Terraform state file?
The state file (`terraform.tfstate`) is where Terraform keeps track of real-world infrastructure it
manages. It maps Terraform resources in code to actual cloud resources (like AWS VPC IDs, EC2
instance IDs).

2. Why is the state file needed?
Keeps record of resources Terraform created, so it knows what to update or destroy. Stores metadata
(like IDs, attributes) fetched from cloud APIs. Allows Terraform to plan changes by comparing desired
state (code) with current state (tfstate). Without state, Terraform would not know what already exists.

3. Why store the state file in S3?
Collaboration: Teams share one state instead of having local copies. Locking with DynamoDB:
Prevents two people from changing state at the same time. Durability: S3 keeps state safe, and
versioning allows rollbacks. Security: Encryption (SSE/KMS) protects sensitive data in state.
Automation: CI/CD pipelines can access a single shared state

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
**Why Do We Need `terraform import`?**


Terraform only knows about resources it created (or that are in its state file).
If something exists in AWS (or Azure, GCP, etc.) but isn’t in Terraform’s state,
Terraform treats it as if it doesn’t exist.
-------------------------------------------------------------------
■ Why you might need to import
1. Bring existing (manually created) resources under Terraform management
 - Example: Someone created a VPC or S3 bucket in the AWS Console, and now you want Terraform to manage it2. Migrate to Infrastructure as Code (IaC)
 - Teams often start by building infra manually → later they move to Terraform.
 - Import avoids deleting/recreating production resources.
3. Avoid downtime / preserve data
 - Some resources can’t be safely destroyed and recreated (e.g., RDS databases, S3 buckets with data, Elastic IPs - Import allows Terraform to manage them without touching existing data.
4. Unify infra management across environments
 - If dev/prod were built by hand (or with CloudFormation/console), you can import them into Terraform.

