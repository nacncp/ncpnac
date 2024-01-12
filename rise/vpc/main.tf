#main.tf (파일명은 상관 없음. 본인이 알아볼 수 있는 이름으로 설정.)
terraform {
 # required_version > "1.2.9" #자신의 terraform 버전으로 설정.

  required_providers {
      aws = {					 #사용할 프로바이더 aws 설정.
          source = "hashicorp/aws"		 #저장 경로.
          version = "~> 3.0"			 #버전 설정
      }
  }
}

provider "aws" {
  region     = "us-east-2" #aws의 리전 설정. ap-northeast-2는 서울리전.
  # access_key 와 secert_key 를 파일에 적어서 구현할 수는 있지만 권장안함.
  # 보안이슈로 파일에 직접적는것보단 export나 위의 configure로 설정하는 것이 좋음.
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
}
