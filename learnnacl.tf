data "aws_vpcs" "SandboxVPCs" {}

data "aws_vpc" "singleVPC" {
    count = length(data.aws_vpcs.SandboxVPCs.ids)
    id = tolist(data.aws_vpcs.SandboxVPCs.ids)[count.index]
}

data "aws_subnets" "SandboxSubnets" {
    filter {
        name = "vpc-id"
        values = [local.all_vpcs[0]]
    }
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.SandboxSubnets.ids)
  id       = each.value
}


output "print_learning"  {
    value = data.aws_subnets.SandboxSubnets
}

locals {
    all_vpcs = data.aws_vpcs.SandboxVPCs.ids
    subnets = [for s in data.aws_subnet.subnet : s.id]
}

output "print_subnets" {
    value = local.subnets
  
}

output "print_vpc" {
  value = local.all_vpcs
  }

output "print_length_vpc" {
  value = length(local.all_vpcs)
  }

resource "aws_network_acl_association" "SandboxNACL_Association" {
    network_acl_id  = aws_network_acl.SandboxNACL.id
    subnet_id       = "[for s in data.aws_subnet.subnet : s.id]"
}

resource "aws_network_acl" "SandboxNACL" {
    vpc_id = local.all_vpcs[0]

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "SandboxNACL"
  }
}