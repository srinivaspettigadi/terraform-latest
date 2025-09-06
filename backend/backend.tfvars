bucket = "my-terraform-state-bucket"
key    = "vpcs/example-vpc/terraform.tfstate"
region = "us-east-1"
encrypt = true
dynamodb_table = "terraform-locks"

