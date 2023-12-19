provider "aws" {
  region = "us-east-1"
  # Oh no! I spilled my keys!
  access_key = "AKIASDUXIESF5SMHJVGZ"
  secret_key = "B2KAEQ+RbNbZ0H9g1m9PSbJ/pbZS/JwB7hQ0uAAQ"
}

resource "aws_instance" "example" {
  ami = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello world" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-sg"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
