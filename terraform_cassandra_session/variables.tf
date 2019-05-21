variable "region" {
  description = "AWS region for VMs"
  default     = "us-east-2"
}

variable "servers" {
  description = "The number of consul servers."
  default     = 3
}

#variable "keypair_path" {
#description = "location of the keypair file on your local machine"
#}

variable "keypair_name" {
  description = "name of ssh key to attach to hosts genereted during apply"
  default     = "hezkeypair"
}

variable "pem_key_name" {
  description = "name of ssh key to attach to hosts genereted during apply"
  default     = "hezkeypair.pem"
}

variable "ami" {
  description = "ami to use - based on region"

  default = {
    "us-east-1" = "ami-0f6cc0e3992de8847"
  }
}

variable user {
  description = "EC2 Linux instance user"
  default     = "ubuntu"
}

variable cluster_name {
  description = "cassandra cluster name"
  default     = "opsschool"
}
