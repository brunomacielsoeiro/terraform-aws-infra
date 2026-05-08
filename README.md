# terraform-aws-infra

Infraestrutura AWS multi-stack com Terraform — complementar ao CloudFormation.

## Arquitetura

Este projeto provisiona uma infraestrutura base na AWS:

- **VPC** com CIDR configurável
- **Subnets** públicas e privadas em múltiplas AZs
- **Security Groups** com regras customizáveis
- **EC2** instância com configuração flexível

## Estrutura do Projeto

```
terraform-aws-infra/
├── main.tf              # Root module - orquestra os módulos
├── variables.tf         # Variáveis globais
├── outputs.tf           # Outputs do projeto
├── providers.tf         # Configuração do provider AWS
├── terraform.tfvars     # Valores das variáveis (não commitar secrets)
├── modules/
│   ├── vpc/             # Módulo VPC + Subnets
│   ├── security_group/  # Módulo Security Groups
│   └── ec2/             # Módulo EC2
└── README.md
```

## Uso

```bash
# Inicializar
terraform init

# Planejar
terraform plan

# Aplicar
terraform apply

# Destruir
terraform destroy
```

## Variáveis Principais

| Variável | Descrição | Default |
|----------|-----------|---------|
| `aws_region` | Região AWS | `us-east-1` |
| `project_name` | Nome do projeto (usado em tags) | `terraform-aws-infra` |
| `vpc_cidr` | CIDR block da VPC | `10.0.0.0/16` |
| `instance_type` | Tipo da instância EC2 | `t3.micro` |

## Objetivo

- Consolidar IaC multi-stack
- Complementar projetos CloudFormation existentes
- Demonstrar boas práticas com módulos Terraform

## Requisitos

- Terraform >= 1.5
- AWS CLI configurado
- Credenciais AWS com permissões adequadas

## Licença

MIT
