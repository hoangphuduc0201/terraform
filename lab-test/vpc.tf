# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name        = "${var.service}-vpc"
    service     = "${var.service}"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.service}-vpc-igw"
    service     = "${var.service}"
  }
}
# (Public) public subnet

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = format(
      "${var.service}-public-%d-subnet",
      count.index + 1,
    )
    service     = "${var.service}"
  }
}

# (Private) datastore subnet

resource "aws_subnet" "datastore" {
  count             = length(var.datastore_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.datastore_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = format(
      "${var.service}-datastore-%d-subnet",
      count.index + 1,
    )
    service     = "${var.service}"
  }
}

# Route table for public

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.service}-public-rtb"
    service     = "${var.service}"
  }
}

resource "aws_route" "internetgatway-route-table-public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc-igw.id
}


# Route table association

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "datastore" {
  count          = length(var.datastore_subnet_cidrs)
  subnet_id      = element(aws_subnet.datastore.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
