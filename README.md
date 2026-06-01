# 🏗️ Terraform AWS Infrastructure

> Projeto de estudos sobre Infraestrutura como Código (IaC) utilizando Terraform na AWS, abordando modularização, VPC multi-AZ, Security Groups e provisionamento de EC2. Atividade acadêmica para cumprimento de horas complementares.

---

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Arquitetura](#arquitetura)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Módulos](#módulos)
- [Como Usar](#como-usar)
- [Variáveis](#variáveis)
- [Outputs](#outputs)
- [Boas Práticas Aplicadas](#boas-práticas-aplicadas)
- [Referências](#referências)

---

## Sobre o Projeto

Este repositório demonstra o provisionamento de infraestrutura AWS utilizando **Terraform** com abordagem modular. O projeto cria uma VPC completa com subnets públicas/privadas, Security Groups e uma instância EC2.

### O que este projeto demonstra

- Modularização de código Terraform
- VPC multi-AZ com subnets públicas e privadas
- Security Groups com regras parametrizáveis
- Validação de variáveis
- Tags padronizadas via `default_tags`
- Separação de responsabilidades (modules)

---

## Arquitetura

```
┌─────────────────────────────────────────────────────────────────────┐
│                         AWS Cloud (us-east-1)                         │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │                     VPC (10.0.0.0/16)                            │ │
│  │                                                                   │ │
│  │  ┌─────────────────────────┐  ┌─────────────────────────┐       │ │
│  │  │  Public Subnet (AZ-a)   │  │  Public Subnet (AZ-b)   │       │ │
│  │  │  10.0.1.0/24            │  │  10.0.2.0/24            │       │ │
│  │  │                         │  │                         │       │ │
│  │  │  ┌───────────────────┐  │  │                         │       │ │
│  │  │  │  EC2 (t3.micro)   │  │  │                         │       │ │
│  │  │  │  Security Group   │  │  │                         │       │ │
│  │  │  └───────────────────┘  │  │                         │       │ │
│  │  └────────────┬────────────┘  └─────────────────────────┘       │ │
│  │               │                                                   │ │
│  │      ┌────────┴────────┐                                         │ │
│  │      │ Internet Gateway │                                         │ │
│  │      └─────────────────┘                                         │ │
│  │                                                                   │ │
│  │  ┌─────────────────────────┐  ┌─────────────────────────┐       │ │
│  │  │  Private Subnet (AZ-a)  │  │  Private Subnet (AZ-b)  │       │ │
│  │  │  10.0.10.0/24           │  │  10.0.11.0/24           │       │ │
│  │  └─────────────────────────┘  └─────────────────────────┘       │ │
│  │                                                                   │ │
│  └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Estrutura do Projeto

```
terraform-aws-infra/
├── main.tf              ← Root module (orquestra os módulos)
├── variables.tf         ← Variáveis globais do projeto
├── outputs.tf           ← Outputs expostos
├── providers.tf         ← Provider AWS + versões + default_tags
├── terraform.tfvars     ← Valores das variáveis
├── modules/
│   ├── vpc/             ← Módulo: VPC + Subnets + IGW + Route Tables
│   ├── security_group/  ← Módulo: Security Groups
│   └── ec2/             ← Módulo: Instância EC2
├── .gitignore
└── README.md
```

---

## Módulos

### VPC Module

| Recurso | Descrição |
|---------|-----------|
| VPC | Rede virtual com CIDR configurável |
| Public Subnets | Subnets com acesso à internet (IGW) |
| Private Subnets | Subnets sem acesso direto à internet |
| Internet Gateway | Permite tráfego de/para internet |
| Route Tables | Roteamento público e privado |

### Security Group Module

| Regra | Porta | Origem | Descrição |
|-------|-------|--------|-----------|
| SSH | 22 | CIDR parametrizável | Acesso remoto |
| HTTP | 80 | 0.0.0.0/0 | Tráfego web |
| HTTPS | 443 | 0.0.0.0/0 | Tráfego web seguro |
| Outbound | All | 0.0.0.0/0 | Saída irrestrita |

### EC2 Module

| Propriedade | Valor |
|-------------|-------|
| Instance Type | Configurável (default: `t3.micro`) |
| Subnet | Primeira subnet pública |
| Security Group | SG do módulo security_group |
| Key Pair | Configurável |

---

## Como Usar

### Pré-requisitos

| Ferramenta | Versão | Instalação |
|-----------|--------|-----------|
| Terraform | >= 1.5 | [terraform.io](https://developer.hashicorp.com/terraform/install) |
| AWS CLI | v2 | [docs.aws.amazon.com](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) |

### Comandos

```bash
# 1. Inicializar (baixa providers e módulos)
terraform init

# 2. Planejar (preview das mudanças)
terraform plan

# 3. Aplicar (cria a infraestrutura)
terraform apply

# 4. Destruir (remove tudo)
terraform destroy
```

### Fluxo Terraform

```
terraform init → terraform plan → terraform apply → terraform destroy
      │                │                │                │
      ▼                ▼                ▼                ▼
  Baixa plugins    Mostra o que     Cria/altera      Remove todos
  e módulos        será criado      recursos         os recursos
```

---

## Variáveis

| Variável | Tipo | Default | Descrição |
|----------|------|---------|-----------|
| `aws_region` | string | `us-east-1` | Região AWS |
| `project_name` | string | `terraform-aws-infra` | Nome do projeto (tags) |
| `environment` | string | `dev` | Ambiente (dev/staging/prod) |
| `vpc_cidr` | string | `10.0.0.0/16` | CIDR da VPC |
| `public_subnet_cidrs` | list(string) | `["10.0.1.0/24", "10.0.2.0/24"]` | Subnets públicas |
| `private_subnet_cidrs` | list(string) | `["10.0.10.0/24", "10.0.11.0/24"]` | Subnets privadas |
| `availability_zones` | list(string) | `["us-east-1a", "us-east-1b"]` | AZs |
| `instance_type` | string | `t3.micro` | Tipo da EC2 |
| `key_name` | string | `""` | Key pair SSH |
| `allowed_ssh_cidrs` | list(string) | `["0.0.0.0/0"]` | CIDRs para SSH |

---

## Outputs

| Output | Descrição |
|--------|-----------|
| `vpc_id` | ID da VPC criada |
| `public_subnet_ids` | IDs das subnets públicas |
| `private_subnet_ids` | IDs das subnets privadas |
| `security_group_id` | ID do Security Group |
| `ec2_instance_id` | ID da instância EC2 |
| `ec2_public_ip` | IP público da EC2 |
| `ec2_private_ip` | IP privado da EC2 |

---

## Boas Práticas Aplicadas

| Prática | Como foi aplicada |
|---------|-------------------|
| Modularização | Cada componente em seu módulo |
| Variáveis tipadas | `type`, `description`, `default` em todas |
| Validação | `validation` block no environment |
| Default tags | `default_tags` no provider (todas as resources herdam) |
| Versionamento de providers | `required_version` e `version` constraints |
| Separação de arquivos | `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf` |
| .gitignore | Ignora `.terraform/`, `*.tfstate`, `*.tfvars` sensíveis |

---

## Conexão com outros projetos

| Projeto | Relação |
|---------|---------|
| `cloudformation-aws-infra` | Mesma infra, ferramenta diferente (comparação) |
| `networking-cloud-fundamentos` | Conceitos de VPC aplicados aqui |
| `seguranca-cloud-iam` | IAM Roles para EC2 |
| `fundamentos-devops` | IaC é prática DevOps |

---

## Referências

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Terraform Modules](https://developer.hashicorp.com/terraform/language/modules)
- [AWS VPC Terraform Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)

---

## 📄 Licença

MIT License
