// VPC 이름
variable "pnoun" {
  type = string
  default = "proper noun"
}
#vpc.tf
resource "aws_vpc" "create_vpc"{
    cidr_block = "10.5.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.pnoun}-vpc"
    }
}
#subnet.tf
#퍼블릭 서브넷
resource "aws_subnet" "create_pub_sub" {
    vpc_id = aws_vpc.create_vpc.id
    cidr_block = "10.5.0.0/24"
    availability_zone = "us-east-2c"
    tags = {
        Name = "${var.pnoun}-public-subnet"
    }
}
#프라이빗 서브넷
resource "aws_subnet" "create_pri_sub" {
    vpc_id = aws_vpc.create_vpc.id
    cidr_block = "10.5.1.0/24"
    availability_zone = "us-east-2c"
    tags = {
        Name ="${var.pnoun}-private-subnet"
    }
}
# igw.tf
resource "aws_internet_gateway" "create_IGW" {
    vpc_id = aws_vpc.create_vpc.id
    tags = {
        Name="${var.pnoun}_IGW"
    }
}
resource "aws_route_table" "create_pub_Route" {
    vpc_id = aws_vpc.create_vpc.id
    route {
    	cidr_block = "0.0.0.0/0"
    	gateway_id = aws_internet_gateway.create_IGW.id 
			#퍼블릭 서브넷에 인터넷 게이트웨이 연결.
    }
    tags = {
	Name = "${var.pnoun}_public_route"
    }
}
#라이팅
#프라이빗 라우팅 테이블
resource "aws_route_table" "create_pri_Route" {
    vpc_id = aws_vpc.create_vpc.id
    tags = {
        Name = "${var.pnoun}-private-route"
    }
}

#퍼블릭 라우팅 테이블 연결
resource "aws_route_table_association" "create_pub_RTAssociation"{
    subnet_id = aws_subnet.create_pub_sub.id
    route_table_id = aws_route_table.create_pub_Route.id
}

#프라이빗 라우팅 테이블 연결
resource "aws_route_table_association" "create_pri_RTAssociation1"{
    subnet_id = aws_subnet.create_pri_sub.id
    route_table_id = aws_route_table.create_pri_Route.id
}

