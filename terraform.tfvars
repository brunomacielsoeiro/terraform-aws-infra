# =============================================================================
# Valores das variáveis - Ajuste conforme seu ambiente
# =============================================================================

aws_region   = "us-east-1"
project_name = "terraform-aws-infra"
environment  = "dev"

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

instance_type     = "t3.micro"
key_name          = ""
allowed_ssh_cidrs = ["0.0.0.0/0"]
