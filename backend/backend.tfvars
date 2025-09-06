bucket = "my-terraform-state-bucket"
key    = "vpcs/example-vpc/terraform.tfstate"
region = "us-east-2"
encrypt = true
dynamodb_table = "terraform-locks"

