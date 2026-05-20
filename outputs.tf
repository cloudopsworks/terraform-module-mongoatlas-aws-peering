##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "mongodbatlas_peering_connection_id" {
  description = "The ID of the MongoDB Atlas network peering connection."
  value       = mongodbatlas_network_peering.this.id
}

output "mongodbatlas_peering_cidr_block" {
  description = "The CIDR block of the MongoDB Atlas network container used for the peering connection."
  value       = mongodbatlas_network_peering.this.atlas_cidr_block
}

output "vpc_peering_accepter_id" {
  description = "The ID of the AWS VPC peering connection accepter resource."
  value       = aws_vpc_peering_connection_accepter.this.id
}

output "vpc_peering_accepter_status" {
  description = "The status of the AWS VPC peering connection accepter (e.g., active, pending-acceptance)."
  value       = aws_vpc_peering_connection_accepter.this.accept_status
}
