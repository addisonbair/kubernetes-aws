resource "aws_instance" "vpn-gateway" {
  ami               = "${var.ami}"
  instance_type     = "${var.instance_type}"
  subnet_id         = "${aws_subnet.vpn-gateway.id}"
  security_groups   = ["${aws_security_group.vpn-gateway.id}"]
  source_dest_check = false

  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = 16
    volume_type           = "gp2"
    delete_on_termination = true
    snapshot_id           = "${var.snapshot_id}"
  }

  associate_public_ip_address = true
  key_name                    = "${aws_key_pair.vpn-gateway.id}"

  tags = {
    Name = "${var.project}-${var.env}-vpn-gateway"
  }
}

resource "aws_security_group" "vpn-gateway" {
  name        = "vpn-gateway-sg"
  vpc_id      = "${var.vpc_id}"
  description = "Security group for vpn gateway (Allow ALL from VPC CIDR)"

  ingress {
    cidr_blocks = ["${var.vpc_cidr}"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}

resource "aws_key_pair" "vpn-gateway" {
  key_name   = "${var.project}-${var.env}-vpn-gateway"
  public_key = "${var.ec2_pubkey}"
}

resource "aws_subnet" "vpn-gateway" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.vpn_subnet_cidr}"
  availability_zone = "${var.az}"

  tags = {
    Name = "${var.project}-${var.env}-vpn-gateway-subnet"
  }
}

resource "aws_route_table" "vpn-gateway" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.project}-${var.env}-rt-vpn-gateway"
  }
}

resource "aws_route" "vpn-gateway-to-igw" {
  route_table_id         = "${aws_route_table.vpn-gateway.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${var.igw_id}"
}

resource "aws_route_table_association" "vpn-gateway" {
  subnet_id      = "${aws_subnet.vpn-gateway.id}"
  route_table_id = "${aws_route_table.vpn-gateway.id}"
}

resource "aws_route" "main-vpc-vpn-route" {
  route_table_id         = "${var.main_vpc_route_table_id}"
  destination_cidr_block = "${var.static_ip_range}"
  instance_id            = "${aws_instance.vpn-gateway.id}"
}

resource "aws_route53_zone_association" "phz" {
  zone_id = "${var.route53_zone_id}"
  vpc_id  = "${var.vpc_id}"
}
