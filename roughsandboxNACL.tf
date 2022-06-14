data "aws_vpcs" "SandboxVPCs" {}


#data "aws_vpc" "SandboxVPC" {
//  count = length(data.aws_vpcs.SandboxVPCs.ids)
//  id    = tolist(data.aws_vpcs.foo.ids)[count.index]
//}

#output "SandboxVPCs" {
//  value = data.aws_vpcs.SandboxVPCs.ids
// }

locals {
  all_subnets = toset(data.aws_subnets.SandboxSubnets.ids)
}

data "aws_subnets" "SandboxSubnets" {
  for_each = toset(data.aws_vpcs.SandboxVPCs.ids)
  vpc_id = each.value
}

#data "aws_subnet" "SandboxSubnet" {
//  for_each = data.aws_subnets.SandboxSubnets.ids
//  id       = each.value
}

resource "aws_network_acl_association" "SandboxNACL_Association" {
#  for_each        = data.aws_subnets.SandboxSubnets.ids
  for_each        = local.all_subnets
  network_acl_id  = aws_network_acl.SandboxNACL.id
  subnet_id       = each.value
}

resource "aws_network_acl" "SandboxNACL" {
  vpc_id = aws_vpc.SandboxVPC.id

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

