Write-Host "=== Terraform 모듈별 테스트 ===" -ForegroundColor Green

Write-Host "`n1. VPC 모듈 테스트" -ForegroundColor Yellow
terraform plan -target=module.vpc -out=vpc-plan.tfplan
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ VPC 모듈 Plan 성공" -ForegroundColor Green
} else {
    Write-Host "❌ VPC 모듈 Plan 실패" -ForegroundColor Red
}

Write-Host "`n2. IAM 모듈 테스트" -ForegroundColor Yellow
terraform plan -target=module.iam -out=iam-plan.tfplan
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ IAM 모듈 Plan 성공" -ForegroundColor Green
} else {
    Write-Host "❌ IAM 모듈 Plan 실패" -ForegroundColor Red
}

Write-Host "`n3. EKS 모듈 테스트" -ForegroundColor Yellow
terraform plan -target=module.eks -out=eks-plan.tfplan
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ EKS 모듈 Plan 성공" -ForegroundColor Green
} else {
    Write-Host "❌ EKS 모듈 Plan 실패" -ForegroundColor Red
}

Write-Host "`n4. RDS 모듈 테스트" -ForegroundColor Yellow
terraform plan -target=module.rds -out=rds-plan.tfplan
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ RDS 모듈 Plan 성공" -ForegroundColor Green
} else {
    Write-Host "❌ RDS 모듈 Plan 실패" -ForegroundColor Red
}

Write-Host "`n5. 전체 모듈 테스트" -ForegroundColor Yellow
terraform plan -out=full-plan.tfplan
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 전체 모듈 Plan 성공" -ForegroundColor Green
} else {
    Write-Host "❌ 전체 모듈 Plan 실패" -ForegroundColor Red
}

Write-Host "`n=== 테스트 완료 ===" -ForegroundColor Green 