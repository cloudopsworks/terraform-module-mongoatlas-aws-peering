##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

data "mongodbatlas_project" "this" {
  count = var.project_name != "" ? 1 : 0
  name  = var.project_name
}

data "mongodbatlas_network_container" "this" {
  container_id = var.atlas_container_id
  project_id   = var.project_id != "" ? var.project_id : data.mongodbatlas_project.this[0].project_id
}

resource "mongodbatlas_network_peering" "this" {
  project_id             = var.project_id != "" ? var.project_id : data.mongodbatlas_project.this[0].project_id
  container_id           = data.mongodbatlas_network_container.this.id
  provider_name          = "AWS"
  aws_account_id         = data.aws_caller_identity.current.account_id
  vpc_id                 = var.vpc.vpc_id
  accepter_region_name   = var.vpc.region
  route_table_cidr_block = var.vpc.cidr_block
}

resource "aws_vpc_peering_connection_accepter" "this" {
  vpc_peering_connection_id = mongodbatlas_network_peering.this.connection_id
  auto_accept               = true
  tags                      = local.all_tags
}

