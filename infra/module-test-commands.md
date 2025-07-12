# Terraform 모듈별 테스트 명령어

## 1. VPC 모듈 테스트

```bash
# VPC 모듈만 Plan
terraform plan -target=module.vpc

# VPC 모듈만 Apply
terraform apply -target=module.vpc

# VPC 출력 확인
terraform output vpc_id
terraform output private_subnet_ids
```

## 2. IAM 모듈 테스트

```bash
# IAM 모듈만 Plan
terraform plan -target=module.iam

# IAM 모듈만 Apply
terraform apply -target=module.iam

# IAM 출력 확인
terraform output eks_admin_role_arn
terraform output eks_admin_role_name
```

## 3. EKS 모듈 테스트

```bash
# EKS 모듈만 Plan
terraform plan -target=module.eks

# EKS 모듈만 Apply
terraform apply -target=module.eks

# EKS 출력 확인
terraform output cluster_name
terraform output cluster_endpoint
terraform output cluster_security_group_id
```

## 4. RDS 모듈 테스트

```bash
# RDS 모듈만 Plan
terraform plan -target=module.rds

# RDS 모듈만 Apply
terraform apply -target=module.rds
```

## 5. 모듈별 상태 확인

```bash
# 전체 상태 확인
terraform show

# 특정 모듈 상태 확인 (JSON)
terraform show -json | jq '.values.root_module.child_modules[] | select(.address == "module.vpc")'
terraform show -json | jq '.values.root_module.child_modules[] | select(.address == "module.iam")'
terraform show -json | jq '.values.root_module.child_modules[] | select(.address == "module.eks")'
terraform show -json | jq '.values.root_module.child_modules[] | select(.address == "module.rds")'
```

## 6. 모듈별 리소스 확인

```bash
# VPC 리소스 확인
terraform state list | grep module.vpc

# IAM 리소스 확인
terraform state list | grep module.iam

# EKS 리소스 확인
terraform state list | grep module.eks

# RDS 리소스 확인
terraform state list | grep module.rds
```

## 7. 모듈별 Destroy 테스트

```bash
# 특정 모듈만 Destroy (주의!)
terraform destroy -target=module.rds
terraform destroy -target=module.eks
terraform destroy -target=module.iam
terraform destroy -target=module.vpc
```

## 8. PowerShell 스크립트 실행

```powershell
# 모듈별 테스트 스크립트 실행
.\test-modules.ps1
```

## 9. 모듈 의존성 확인

```bash
# 의존성 그래프 생성
terraform graph | dot -Tsvg > dependency-graph.svg

# 특정 모듈의 의존성 확인
terraform graph | grep -A 10 -B 10 "module.vpc"
terraform graph | grep -A 10 -B 10 "module.iam"
terraform graph | grep -A 10 -B 10 "module.eks"
terraform graph | grep -A 10 -B 10 "module.rds"
```

## 10. 모듈별 변수 확인

```bash
# VPC 모듈 변수 확인
terraform console
> module.vpc
> module.vpc.vpc_id

# IAM 모듈 변수 확인
> module.iam
> module.iam.eks_admin_role_arn

# EKS 모듈 변수 확인
> module.eks
> module.eks.cluster_name
``` 