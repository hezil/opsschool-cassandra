# Create the user-data for the Consul server

# Create the Consul cluster
resource "aws_instance" "cassandra_servers" {
  count = "${var.servers}"
  ami   = "${lookup(var.ami, var.region)}"

  instance_type = "t3a.medium"
  key_name      = "${aws_key_pair.opsschool_cassandra_key.key_name}"

  iam_instance_profile   = "${aws_iam_instance_profile.cassandra-discover.name}"
  vpc_security_group_ids = ["${aws_security_group.cassandra-server-sec.id}"]

  tags = {
    Name = "cassandra-server-${count.index+1}"
    type = "cassandra-server"
  }

}

data "template_file" "seeds" {
  count    = "${var.servers}"
  template = "${aws_instance.cassandra_servers.*.private_ip[count.index]}"
}

# Prepare the cassandra.yaml file from template
data "template_file" "cassandra_yaml" {
  count    = "${var.servers}"
  template = "${file("${path.module}/files/cassandra.yaml")}"

  vars {
    cluster_name = "${var.cluster_name}"
    seeds        = "${join(",", data.template_file.seeds.*.rendered)}"
    server_ip    = "${aws_instance.cassandra_servers.*.private_ip[count.index]}"
  }
}

# Copy the prepared files to the cassandra servers
resource "null_resource" "copy_yaml" {
  count = "${var.servers}"

  provisioner "file" {
    content     = "${data.template_file.cassandra_yaml.*.rendered[count.index]}"
    destination = "./cassandra.yaml"

    connection {
      host = "${aws_instance.cassandra_servers.*.public_ip[count.index]}"
      user = "${var.user}"
      type = "ssh"

      private_key = "${file("${path.module}/${local_file.private_key.filename}")}"
    }
  }
}

resource "null_resource" "move_cassandra_yaml_to_etc" {
  count = "${var.servers}"

  provisioner "remote-exec" {
    inline = [
      "sudo cp ./cassandra.yaml /etc/dse/cassandra/cassandra.yaml",
      "sudo chown cassandra /etc/dse/cassandra/cassandra.yaml",
    ]

    connection {
      host        = "${aws_instance.cassandra_servers.*.public_ip[count.index]}"
      user        = "${var.user}"
      type        = "ssh"
      private_key = "${file("${path.module}/${local_file.private_key.filename}")}"
    }
  }

  depends_on = ["null_resource.copy_yaml", "null_resource.chmod_400_key"]
}

output "servers" {
  value = ["${aws_instance.cassandra_servers.*.public_ip}"]
}
