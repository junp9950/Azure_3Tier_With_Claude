# Azure 3-Tier Architecture with Terraform

이 프로젝트는 Terraform을 사용하여 Azure에 3-tier 웹 애플리케이션 아키텍처를 구축합니다.

## 아키텍처 개요

- **Presentation Tier (웹 계층)**: 로드 밸런서와 웹 서버 VM들
- **Application Tier (애플리케이션 계층)**: 애플리케이션 로직을 처리하는 VM들
- **Data Tier (데이터 계층)**: MySQL Flexible Server

## 구성 요소

### 네트워크
- Virtual Network (10.0.0.0/16)
- Web Subnet (10.0.1.0/24)
- App Subnet (10.0.2.0/24)
- Data Subnet (10.0.3.0/24)
- Network Security Groups (각 계층별)

### Presentation Tier
- Azure Load Balancer (Standard SKU)
- 2개의 웹 서버 VM (Ubuntu 22.04)
- Nginx 웹 서버 자동 설치
- Availability Set

### Application Tier
- 2개의 애플리케이션 서버 VM (Ubuntu 22.04)
- Java 11 JDK 자동 설치
- Availability Set

### Data Tier
- MySQL Flexible Server
- Private DNS Zone
- Database: app_database

## 사전 요구사항

1. Azure CLI 설치 및 로그인
2. Terraform 설치
3. SSH 키 페어 생성 (`~/.ssh/id_rsa.pub`)

## 배포 방법

1. **SSH 키 생성** (없는 경우):
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

2. **Terraform 변수 설정**:
```bash
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvars 파일을 편집하여 필요한 값들을 설정
```

3. **Terraform 초기화**:
```bash
terraform init
```

4. **계획 검토**:
```bash
terraform plan
```

5. **배포 실행**:
```bash
terraform apply
```

## 접속 방법

배포 완료 후 다음 정보를 확인할 수 있습니다:

- 로드 밸런서 퍼블릭 IP: `terraform output load_balancer_public_ip`
- 웹 서버 퍼블릭 IP들: `terraform output web_vm_public_ips`
- MySQL 서버 FQDN: `terraform output mysql_server_fqdn`

## 보안 설정

- 웹 계층: HTTP(80), HTTPS(443), SSH(22) 허용
- 애플리케이션 계층: 웹 서브넷에서만 8080 포트 접근 허용
- 데이터 계층: 애플리케이션 서브넷에서만 MySQL(3306) 접근 허용

## 정리

리소스 삭제:
```bash
terraform destroy
```

## 주의사항

- MySQL 관리자 비밀번호는 terraform.tfvars에서 안전하게 관리하세요
- 실제 운영 환경에서는 더 강력한 보안 설정이 필요합니다
- SSH 키는 안전하게 보관하세요