provider "aws" {
  region = "us-east-1"
  # Oh no! I spilled my keys!
  access_key = "AKIA4TJMYTRGR2YHM4KU"
  secret_key = "QCbAlLMUzuUXCRN5ecfma3/uUg4jw7tYTa3QKHqC"
}

resource "aws_instance" "example" {
  ami = "ami-079db87dc4c10ac91"
  instance_type = "t2.micro"
}
