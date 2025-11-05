# DB Subnet Group for RDS
resource "aws_db_subnet_group" "product_db_subnet" {
  name = "product-db-subnet-group"
  subnet_ids = [
    aws_subnet.product_v1_subnet_1c_private.id,
    aws_subnet.product_v1_subnet_1d_private.id
  ]

  tags = {
    Name = "Product DB subnet group"
  }
}

resource "aws_db_instance" "product_mydb" {
  allocated_storage     = 20
  max_allocated_storage = 100
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.micro"

  db_name              = "productdb"
  username             = "admin"
  password             = "Admin12345" # Use secrets manager or SSM in prod
  parameter_group_name = "default.mysql8.0"

  skip_final_snapshot = true # set to false in prod
  publicly_accessible = false

  vpc_security_group_ids = [aws_security_group.product_v1_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.product_db_subnet.id

  tags = {
    Name = "MyRDSInstance"
  }
}
