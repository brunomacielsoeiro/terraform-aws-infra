variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet onde a EC2 será lançada"
  type        = string
}

variable "security_group_id" {
  description = "ID do Security Group para a EC2"
  type        = string
}

variable "key_name" {
  description = "Nome do key pair para acesso SSH"
  type        = string
  default     = ""
}
