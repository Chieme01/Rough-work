# Attachments
// Policy is attached at the root OU so Sandbox OU and other accounts can inherit it; to prevent Sandbox access.
locals {
  OU-Isolation-attachments = [
    local.root_ou_id
  ]
}

resource "aws_organizations_policy_attachment" "sandbox_ou" {
  for_each  = toset(local.OU-Isolation-attachments)
  policy_id = aws_organizations_policy.scp_sandbox_isolation.id
  target_id = each.value
}
  
# Policy
// The Policy condition requires that aws:ResourceOrgPaths and aws:PrincipalOrgPaths must be equal to each other. 
// With this requirement, the principal (Sandbox) will be denied access to resources not in the same organization unit (i.e Sandbox_OU) or it's children OUs.
// The use of the first asterisk (*) between organization ID and OU ID is because OU IDs are unique within organization. This means specifying the full path is not necessary to select the needed OU. 
// The second asterisk (*), at the end of the path, is used to specify that all children OUs of Sandbox are included.
resource "aws_organizations_policy" "scp_sandbox_isolation" {
  name        = "scp-sandbox-isolation"
  description = "Sandbox Isolation Policy - This denies Sandbox from accessing other accounts and resources, outside of the Sandbox OU"
  
  content = <<CONTENT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenySandboxOUAccessToExternalResources",
      "Effect": "Deny",
      "Principal": {
          "aws:PrincipalOrgPaths":[
          "${local.constants.org_id}/*/${local.constants.sandbox_ou}/*"
          ]
      },
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "ForAllValues:StringNotLike": {
          "aws:ResourceOrgPaths": [
          "${local.constants.org_id}/*/${local.constants.sandbox_ou}/*"
          ]
        }
      }
    }
  ]
}
CONTENT
}