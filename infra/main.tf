# EKS
module "eks" {
  source       = "./modules/eks"
  cluster_name = "memo-eks"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
  project      = "memo-note"
}



# RDS
module "rds" {
  source              = "./modules/rds"
  name                = "myapp-mysql"
  engine_version      = "8.0.36"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  db_name             = "memo"
  username            = var.db_username
  password            = var.db_password
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.rds.id]
  tags                = var.tags
}
