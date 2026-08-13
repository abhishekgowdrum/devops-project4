resource "aws_vpc" "vpc1"{
    cidr_block = var.vpc1_cidr
    tags ={
        Name = var.vpc1_name
    }
}

resource "aws_subnet" "sub1"{
    vpc_id=aws_vpc.vpc1.id
    cidr_block = var.sub1_cidr
    availability_zone = "us-west-2a"
    tags = {
        Name = var.sub1_name
    }
}

resource "aws_internet_gateway" "IGW1"{
    vpc_id=aws_vpc.vpc1.id
    tags = {
        Name = var.IGW1_name
    }
}

resource "aws_route_table" "RT1"{
    vpc_id=aws_vpc.vpc1.id
    route {
        cidr_block =var.RT1_cidr
        gateway_id =aws_internet_gateway.IGW1.id
    }
    tags = {
        Name = var.RT1_name
    }
}

resource "aws_route_table_association" "RTA"{
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.RT1.id
}

resource "aws_security_group" "SG1"{
    vpc_id = aws_vpc.vpc1.id
    ingress {
        from_port = var.SG1_from_port
         to_port = var.SG1_to_port
        cidr_blocks =[var.SG1_cidr]
        protocol="tcp"
    }
    ingress {
        from_port = var.SG1_from_port1
        to_port = var.SG1_to_port1
        cidr_blocks =[var.SG1_cidr]
        protocol="tcp"
    }
    egress  {
        from_port = var.SG1_from_egrees
        to_port =  var.SG1_to_egrees
        cidr_blocks =[var.SG1_cidr]
        protocol="-1"
    }
    tags = {
        Name = var.SG1_name
    }
}

resource "aws_key_pair" "west2" {
  key_name   = "west2"
  public_key = file("/tmp/west2.pub")
}

resource "aws_instance" "EC2"{
    ami = var.EC2_ami
    instance_type = var.EC2_Instance_type
    key_name = aws_key_pair.west2.key_name
    subnet_id = aws_subnet.sub1.id
    associate_public_ip_address = true
    vpc_security_group_ids =[aws_security_group.SG1.id]
    tags = {
        Name = var.EC2_Name
    }
}

