#main ec2 server created using the launch template
#bastion server
resource "aws_instance" "bastion_instance" {
  ami           = "ami-02d26659fd82cf299" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.product_v1_subnet_1a_public.id

  # key_name      = "my-key-pair" # Replace with your key pair name
  vpc_security_group_ids = [aws_security_group.product_v1_sg.id] # Security groups in VPC

  tags = {
    Name = "bastion-instance"
  }
  #user data in ubuntu
  user_data = base64encode(<<EOF
#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y
sudo apt-get install -y nginx
  #user data in ubuntu
  user_data = base64encode(<<EOF
#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
EOF
  )

}
