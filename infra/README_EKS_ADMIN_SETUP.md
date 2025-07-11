# EKS Admin Role 설정 가이드

이 프로젝트는 AWS EKS 클러스터에 대한 관리자 접근 권한을 제공하는 `eks-admin-role` IAM Role을 생성하고, 이를 `aws-auth` ConfigMap에 등록하여 `kubectl` 접근을 가능하게 합니다.

## 📁 폴더 구조

```
infra/
├── main.tf                    # 메인 Terraform 설정
├── variables.tf               # 변수 정의
├── outputs.tf                 # 출력 정의
├── terraform.tfvars           # 변수 값 설정
├── modules/
│   ├── iam/                   # IAM Role 관리
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── eks-auth/              # aws-auth ConfigMap 관리
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── eks/                   # 기존 EKS 클러스터
└── README_EKS_ADMIN_SETUP.md  # 이 파일
```

## 🚀 설정 단계

### 1. IAM 사용자 ARN 설정

`terraform.tfvars` 파일에서 실제 IAM 사용자 ARN으로 변경하세요:

```hcl
admin_user_arn = "arn:aws:iam::YOUR_ACCOUNT_ID:user/YOUR_USERNAME"
```

### 2. Terraform 실행

```bash
# 초기화
terraform init

# 계획 확인
terraform plan

# 적용
terraform apply
```

### 3. kubectl 설정

Terraform 실행 완료 후, 다음 명령어로 kubectl을 설정하세요:

```bash
# eks-admin-role을 사용하여 kubeconfig 업데이트
aws eks update-kubeconfig --region ap-northeast-2 --name memo-eks-cluster --role-arn $(terraform output -raw eks_admin_role_arn)
```

### 4. 접근 확인

```bash
# 클러스터 정보 확인
kubectl cluster-info

# 노드 목록 확인
kubectl get nodes

# 네임스페이스 목록 확인
kubectl get namespaces
```

## 🔧 생성되는 리소스

### IAM Role
- **이름**: `eks-admin-role`
- **권한**: `AdministratorAccess` 정책
- **Assume 권한**: 지정된 IAM 사용자

### aws-auth ConfigMap
- **위치**: `kube-system` 네임스페이스
- **역할**: `eks-admin-role`을 `system:masters` 그룹에 매핑
- **권한**: 클러스터 관리자 권한

## 📋 출력 값

Terraform 실행 후 다음 출력을 확인할 수 있습니다:

```bash
# EKS 클러스터 정보
terraform output eks_cluster_name
terraform output eks_cluster_endpoint

# IAM Role 정보
terraform output eks_admin_role_arn
terraform output eks_admin_role_name
```

## ⚠️ 주의사항

1. **보안**: `AdministratorAccess` 정책은 매우 강력한 권한을 제공합니다. 프로덕션 환경에서는 더 세분화된 권한을 사용하는 것을 권장합니다.

2. **IAM 사용자**: `admin_user_arn` 변수에 실제 IAM 사용자의 ARN을 입력해야 합니다.

3. **리전**: 현재 설정은 `ap-northeast-2` (서울) 리전을 사용합니다.

## 🛠️ 문제 해결

### kubectl 접근 오류
```bash
# AWS CLI 자격 증명 확인
aws sts get-caller-identity

# EKS 클러스터 상태 확인
aws eks describe-cluster --name memo-eks-cluster --region ap-northeast-2
```

### aws-auth ConfigMap 확인
```bash
kubectl get configmap aws-auth -n kube-system -o yaml
``` 