# VPC 이름
variable "pnoun" {
  type = string
  default = "proper noun"
}
#vpc_az_s 정의
variable "vpc_az_s" {
    type = list
    default = ["2a", "2c"]  
}
#vpc_az 정의
variable "vpc_az" {
    type = list
    default = ["us-east-2a", "us-east-2c"]  
}

#vpc_cidr 정의
variable "vpc_cidr" {
    type = string
    default = "10.5.0.0/16"
}
#subnet_cidr 정의
variable "public_subnet_cidr" {
    type = list
    default = ["10.5.1.0/24", "10.5.2.0/24"]
}
variable "private_subnet_cidr" {
    type = list
    default = ["10.5.11.0/24", "10.5.12.0/24"]
}

#vpc.tf
resource "aws_vpc" "create_vpc"{
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    tags = {
        Name = "${var.pnoun}-vpc"
    }
}
#subnet.tf
#퍼블릭 서브넷
resource "aws_subnet" "create_pub_sub" {
    count = length(var.vpc_az_s)
    vpc_id = aws_vpc.create_vpc.id
    cidr_block = "${var.public_subnet_cidr[count.index]}"
    availability_zone = "${var.vpc_az[count.index]}"
    tags = {
        Name = "${var.pnoun}-public-subnet-${count.index}"
    }
}
#프라이빗 서브넷
resource "aws_subnet" "create_pri_sub" {
    count = length(var.vpc_az_s)
    vpc_id = aws_vpc.create_vpc.id
    cidr_block = "${var.private_subnet_cidr[count.index]}"
    availability_zone = "${var.vpc_az[count.index]}"
    tags = {
        Name = "${var.pnoun}-private-subnet-${count.index}"
    }
}
# igw.tf
resource "aws_internet_gateway" "create_IGW" {
    vpc_id = aws_vpc.create_vpc.id
    tags = {
        Name="${var.pnoun}_IGW"
    }
}
#라이팅
#퍼블릭 라우팅 테이블
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
#프라이빗 라우팅 테이블
resource "aws_route_table" "create_pri_Route" {
    vpc_id = aws_vpc.create_vpc.id
    tags = {
        Name = "${var.pnoun}-private-route"
    }
}

#퍼블릭 라우팅 테이블 연결
resource "aws_route_table_association" "create_pub_RTAssociation"{
    count = length(aws_route_table.create_pub_Route)
    subnet_id = "${element(aws_subnet.create_pub_sub.*.id, count.index)}"
    route_table_id = "${aws_route_table.create_pub_Route.id}"
}

#프라이빗 라우팅 테이블 연결
resource "aws_route_table_association" "create_pri_RTAssociation"{
    count = length(aws_route_table.create_pri_Route)
    subnet_id = "${element(aws_subnet.create_pri_sub.*.id, count.index)}"
    route_table_id = "${aws_route_table.create_pri_Route.id}"
}
