region  = "ap-northeast-2"
profile = "base-user"
project = "memo"

# IAM Admin User ARN
admin_user_arn = "arn:aws:iam::571170910853:user/lion3team04"   # 이부분 업데이트 필요 arn:aws:iam::727646470302:user/lion3team04

# EKS
cluster_name    = "memo-eks-cluster"
cluster_version = "1.29"

# S3
bucket_name = "bu12k3e45t6"    #memo-image-bucket

# RDS
db_name = "memodb"
db_username = "memo"
db_password = "memomemomim"

# IRSA용 OIDC 설정
# oidc_provider_url = "oidc.eks.ap-northeast-2.amazonaws.com/id/174009068958FC8C33EFD5A601D6A4E8"
# oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.ap-northeast-2.amazonaws.com/id/174009068958FC8C33EFD5A601D6A4E8"
