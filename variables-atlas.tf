##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# project_id: "" # (Optional) The MongoDB Atlas project ID. Mutually exclusive with project_name. Default: ""
variable "project_id" {
  description = "(Optional) The ID of the project where the peering connection will be created. Mutually exclusive with project_name."
  type        = string
  default     = ""
}

# project_name: "" # (Optional) The MongoDB Atlas project name. Mutually exclusive with project_id. Default: ""
variable "project_name" {
  description = "(Optional) The name of the project where the peering connection will be created. Mutually exclusive with project_id."
  type        = string
  default     = ""
}

# atlas_container_id: "container-id" # (Required) The ID of the Atlas network container for this peering.
variable "atlas_container_id" {
  description = "(Required) The ID of the MongoDB Atlas network container to peer with."
  type        = string
}

## settings:
#   enable_vpc_dns_resolution: true     # (Optional) Allow DNS resolution across the peering connection. Default: true
#   enable_vpc_route_tables: false      # (Optional) Add Atlas CIDR routes to the VPC route tables. Default: false
#   enable_mongo_ip_access_list: false  # (Optional) Add the VPC CIDR to the Atlas project IP access list. Default: false
variable "settings" {
  description = "(Optional) Behaviour settings for the peering module. Controls DNS resolution, route table updates, and Atlas IP access list."
  type        = any
  default     = {}
}

## vpc:
#   vpc_id: "vpc-12345678"          # (Required) The ID of the AWS VPC to peer with.
#   region: "us-east-1"             # (Required) The AWS region of the VPC (e.g. us-east-1, eu-west-1). Default: "us-east-1"
#   cidr_block: "10.0.0.0/16"      # (Required) The CIDR block of the AWS VPC. Default: "0.0.0.0/0"
#   route_table_ids: []             # (Optional) List of route table IDs to update when enable_vpc_route_tables is true. Default: []
variable "vpc" {
  description = "(Required) The AWS VPC configuration for the peering connection."
  type = object({
    vpc_id          = string
    region          = string
    cidr_block      = string
    route_table_ids = list(string)
  })
  default = {
    vpc_id          = ""
    region          = "us-east-1"
    cidr_block      = "0.0.0.0/0"
    route_table_ids = []
  }
}
