region  = "ap-northeast-2"
profile = "base-user"
project = "memo"

# IAM Admin User ARN
admin_user_arn = "arn:aws:iam::727646470302:user/lion3team04"

# EKS
cluster_name    = "memo-eks-cluster"
cluster_version = "1.29"

# S3
bucket_name = "memo-image-bucket" 

# Bastion EC2용 키페어 이름
# AWS 콘솔에서 "bastion-key"라는 이름으로 키페어를 생성하고, .pem 파일을 반드시 로컬에 다운로드 받아야 합니다.
# 이 값은 EC2 인스턴스 SSH 접속에 사용됩니다.
bastion_key_name = "bastion-key"

# RDS
# db_name은 반드시 영문자로 시작하고, 영문+숫자만 사용할 수 있습니다. (예: memodb)
db_name = "memodb"
db_username = "memo"
db_password = "memomemomim"

# IRSA용 OIDC 설정
oidc_provider_url = "oidc.eks.ap-northeast-2.amazonaws.com/id/DD65EEF4A3302F7E1BEACEF069452752"
oidc_provider_arn = "arn:aws:iam::727646470302:oidc-provider/oidc.eks.ap-northeast-2.amazonaws.com/id/DD65EEF4A3302F7E1BEACEF069452752"
