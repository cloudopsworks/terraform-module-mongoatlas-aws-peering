## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.35 |
| <a name="requirement_mongodbatlas"></a> [mongodbatlas](#requirement\_mongodbatlas) | ~> 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.35 |
| <a name="provider_mongodbatlas"></a> [mongodbatlas](#provider\_mongodbatlas) | ~> 2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection_accepter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [mongodbatlas_network_peering.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/network_peering) | resource |
| [mongodbatlas_project_ip_access_list.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project_ip_access_list) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [mongodbatlas_network_container.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/data-sources/network_container) | data source |
| [mongodbatlas_project.this](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/data-sources/project) | data source |
| [mongodbatlas_roles_org_id.current](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/data-sources/roles_org_id) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atlas_container_id"></a> [atlas\_container\_id](#input\_atlas\_container\_id) | (Required) The ID of the MongoDB Atlas network container to peer with. | `string` | n/a | yes |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | (Optional) The ID of the project where the peering connection will be created. Mutually exclusive with project\_name. | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | (Optional) The name of the project where the peering connection will be created. Mutually exclusive with project\_id. | `string` | `""` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | (Optional) Behaviour settings for the peering module. Controls DNS resolution, route table updates, and Atlas IP access list. | `any` | `{}` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | (Required) The AWS VPC configuration for the peering connection. | <pre>object({<br/>    vpc_id          = string<br/>    region          = string<br/>    cidr_block      = string<br/>    route_table_ids = list(string)<br/>  })</pre> | <pre>{<br/>  "cidr_block": "0.0.0.0/0",<br/>  "region": "us-east-1",<br/>  "route_table_ids": [],<br/>  "vpc_id": ""<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mongodbatlas_peering_cidr_block"></a> [mongodbatlas\_peering\_cidr\_block](#output\_mongodbatlas\_peering\_cidr\_block) | The CIDR block of the MongoDB Atlas network container used for the peering connection. |
| <a name="output_mongodbatlas_peering_connection_id"></a> [mongodbatlas\_peering\_connection\_id](#output\_mongodbatlas\_peering\_connection\_id) | The ID of the MongoDB Atlas network peering connection. |
| <a name="output_vpc_peering_accepter_id"></a> [vpc\_peering\_accepter\_id](#output\_vpc\_peering\_accepter\_id) | The ID of the AWS VPC peering connection accepter resource. |
| <a name="output_vpc_peering_accepter_status"></a> [vpc\_peering\_accepter\_status](#output\_vpc\_peering\_accepter\_status) | The status of the AWS VPC peering connection accepter (e.g., active, pending-acceptance). |
