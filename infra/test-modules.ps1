Write-Host "=== Terraform 모듈별 테스트 ===" -ForegroundColor Green

# 모듈 목록
$modules = @("vpc", "iam", "eks", "rds")

foreach ($m in $modules) {
    Write-Host "`n$m 모듈 테스트" -ForegroundColor Yellow
    Write-Host "$m 모듈 Plan 확인..." -ForegroundColor Cyan
    terraform plan -target="module.$m" -out="$m-plan.tfplan"
    $code = $LASTEXITCODE
    if ($code -eq 0) {
        Write-Host "✅ $m 모듈 Plan 성공" -ForegroundColor Green
    } else {
        Write-Host "❌ $m 모듈 Plan 실패" -ForegroundColor Red
    }
}

Write-Host "`n전체 Plan 확인..." -ForegroundColor Cyan
terraform plan -out=full-plan.tfplan
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 전체 모듈 Plan 성공" -ForegroundColor Green
} else {
    Write-Host "❌ 전체 모듈 Plan 실패" -ForegroundColor Red
}
