##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "mongodbatlas_peering_connection_id" {
  value = mongodbatlas_network_peering.this.id
}

output "mongodbatlas_peering_cidr_block" {
  value = mongodbatlas_network_peering.this.atlas_cidr_block
}

output "vpc_peering_accepter_id" {
  value = aws_vpc_peering_connection_accepter.this.id
}

output "vpc_peering_accepter_status" {
  value = aws_vpc_peering_connection_accepter.this.accept_status
}