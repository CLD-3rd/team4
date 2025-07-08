# EKS
module "eks" {
  source       = "./modules/eks"
  cluster_name = "memo-eks"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
  project      = "memo-note"
}
