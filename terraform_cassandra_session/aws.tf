provider "aws" {
  region  = "${var.region}"
  version = "~> 1.0"
}

resource "tls_private_key" "opsschool_cassandra_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "opsschool_cassandra_key" {
  key_name   = "opsschool_cassandra_key"
  public_key = "${tls_private_key.opsschool_cassandra_key.public_key_openssh}"
}

resource "null_resource" "chmod_400_key" {
  provisioner "local-exec" {
    command = "chmod 400 ${path.module}/${local_file.private_key.filename}"
  }
}

resource "local_file" "private_key" {
  sensitive_content = "${tls_private_key.opsschool_cassandra_key.private_key_pem}"
  filename          = "${var.pem_key_name}"
}

resource "aws_security_group" "cassandra-server-sec" {
  name        = "cassandra-server-sec"
  description = "Allow ssh & cassandra inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all inside security group"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ssh from the world"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outside security group"
  }
}

# Create an IAM role for the auto-discover
resource "aws_iam_role" "cassandra-discover" {
  name               = "opsschool-cassandra-discover"
  assume_role_policy = "${file("${path.module}/templates/policies/assume-role.json")}"
}

# Create the policy
resource "aws_iam_policy" "cassandra-discover" {
  name        = "opsschool-cassandra-discover"
  description = "Allows cassandra nodes to describe instances for discovering."
  policy      = "${file("${path.module}/templates/policies/describe-instances.json")}"
}

# Attach the policy
resource "aws_iam_policy_attachment" "cassandra-discover" {
  name       = "opsschool-cassandra-discover"
  roles      = ["${aws_iam_role.cassandra-discover.name}"]
  policy_arn = "${aws_iam_policy.cassandra-discover.arn}"
}

# Create the instance profile
resource "aws_iam_instance_profile" "cassandra-discover" {
  name = "opsschool-cassandra-discover"
  role = "${aws_iam_role.cassandra-discover.name}"
}
