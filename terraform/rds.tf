# rds subnet group
resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [
    data.aws_subnets.default_vpc_subnets.ids[0],
    data.aws_subnets.default_vpc_subnets.ids[1]
  ]

  tags = {
    Name = "My DB Subnet Group"
  }
}
# RDS Instance (Free Tier eligible)
resource "aws_db_instance" "my_mysql" {
  identifier             = "mydb"
  allocated_storage      = 20                 # ✅ Free Tier (20 GB)
  max_allocated_storage  = 20
  storage_type           = "gp2"              # ✅ Free Tier eligible
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"      # ✅ Free Tier eligible
  db_name                = "mydb"
  username               = "admin"
  password               = var.db_password # ⚠️ move to .tfvars or Secrets Manager
  parameter_group_name   = "default.mysql8.0"

  publicly_accessible    = false   # change to false for private DB
  skip_final_snapshot    = true   # avoid snapshot charges
  multi_az               = false  # ✅ Multi-AZ costs extra
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name

  tags = {
    Name = "myrdsdb"
  }
}

# Output DB endpoint
output "rds_endpoint" {
  value = aws_db_instance.my_mysql.endpoint
}
