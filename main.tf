# Create VPC
resource "aws_vpc" "new-vpc-ds" {
  cidr_block = "172.16.0.0/20"
  enable_dns_hostnames = true
  tags = {
    Name = "test-vpc"
  }
}

resource "aws_internet_gateway" "test-public" {
  vpc_id = aws_vpc.new-vpc-ds.id
  tags = {
    Name = "test-GW_pub"
  }
}

resource "aws_subnet" "test-subnet1" {
  vpc_id = aws_vpc.new-vpc-ds.id
  cidr_block = "172.16.0.0/20"
  tags = {
    Name = "test-subnet_pub"
  }
}
resource "aws_route_table" "test_route" {
  vpc_id = aws_vpc.new-vpc-ds.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-public.id
      }
  tags = {
    Name = "test_route1_pub"
  }
}

resource "aws_route_table_association" "aws_route_associate1" {
  route_table_id = aws_route_table.test_route.id
  subnet_id =  aws_subnet.test-subnet1.id
}

resource "aws_subnet" "test_private" {
  vpc_id = aws_vpc.new-vpc-ds.id
  cidr_block = "172.16.32.0/20"
  tags = {
    Name = "PrivateSub"
  }
}

resource "aws_eip" "eip_private" {
  vpc = true
  }

resource "aws_nat_gateway" "aws_nat_test" {
  allocation_id = aws_eip.eip_private.id
  subnet_id = aws_subnet.test-subnet1.id
  tags = {
    Name = "aws_nat-pri"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = "aws_vpc.new-vpc-ds.id"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.aws_nat_test.id
  }
    tags = {
      Name = "test_route1_pub"
    }
  }

resource "aws_route_table_association" "aws_rt_ass_private" {
  route_table_id = aws_route_table.private1.id
  subnet_id = aws_subnet.test_private.id
}


