data "aws_vpcs" "SandboxVPCs" {}

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

locals {
    all_vpcs = data.aws_vpcs.SandboxVPCs.ids
    subnets = [for s in data.aws_subnet.subnet : s.id]
}
