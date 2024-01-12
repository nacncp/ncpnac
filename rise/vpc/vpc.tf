
#vpc.tf
resource "aws_vpc" "rising-vpc"{
    cidr_block = "10.5.0.0/16"
    enable_dns_hostnames = true
}
#subnet.tf
#퍼블릭 서브넷
resource "aws_subnet" "rising-pub-sub" {
    vpc_id = aws_vpc.rising-vpc.id
    cidr_block = "10.5.0.0/24"
    availability_zone = "us-east-2c"
    tags = {
        Name = "rising-public-subnet"
    }
}
#프라이빗 서브넷
resource "aws_subnet" "rising-pri-sub1" {
    vpc_id = aws_vpc.rising-vpc.id
    cidr_block = "10.5.1.0/24"
    availability_zone = "us-east-2c"
    tags = {
        Name ="rising-private-subnet1"
    }
}
resource "aws_subnet" "rising-pri-sub2" {
    vpc_id = aws_vpc.rising-vpc.id
    cidr_block = "10.5.2.0/24"
    availability_zone = "us-east-2a"
    tags = {
        Name = "rising-private-subnet2"
    }
}
# igw.tf
resource "aws_internet_gateway" "risingIGW" {
    vpc_id = aws_vpc.rising-vpc.id
    tags = {
        Name="rising-IGW"
    }
}
resource "aws_route_table" "rising-pub-Route" {
    vpc_id = aws_vpc.rising-vpc.id
    route {
    	cidr_block = "0.0.0.0/0"
    	gateway_id = aws_internet_gateway.risingIGW.id 
			#퍼블릭 서브넷에 인터넷 게이트웨이 연결.
    }
    tags = {
	Name = "rising-public-route"
    }
}
#라이팅
#프라이빗 라우팅 테이블
resource "aws_route_table" "rising-pri-Route" {
    vpc_id = aws_vpc.rising-vpc.id
    tags = {
        Name = "rising-private-route"
    }
}

#퍼블릭 라우팅 테이블 연결
resource "aws_route_table_association" "rising-pub-RTAssociation"{
    subnet_id = aws_subnet.rising-pub-sub.id
    route_table_id = aws_route_table.rising-pub-Route.id
}

#프라이빗 라우팅 테이블 연결
resource "aws_route_table_association" "rising-pri-RTAssociation1"{
    subnet_id = aws_subnet.rising-pri-sub1.id
    route_table_id = aws_route_table.rising-pri-Route.id
}
resource "aws_route_table_association" "rising-pri-RTAssociation2"{
    subnet_id = aws_subnet.rising-pri-sub2.id
    route_table_id = aws_route_table.rising-pri-Route.id
}
