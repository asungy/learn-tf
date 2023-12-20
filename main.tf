provider "aws" {
  region = "us-east-1"
  # Oh no! I spilled my keys!
  access_key = "AKIAZ5FQAPSOHMGL6NM3"
  secret_key = "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"
}

variable "server_port" {
  description = "The server port"
  type = number
  default = 8080
}

resource "aws_instance" "example" {
  ami = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello world" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-sg"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = aws_instance.example.public_ip
  description = "The public IP of the web server"
}
