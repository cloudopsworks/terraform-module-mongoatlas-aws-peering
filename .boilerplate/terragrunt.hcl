locals {
  local_vars  = yamldecode(file("./inputs.yaml"))
  spoke_vars  = yamldecode(file(find_in_parent_folders("spoke-inputs.yaml")))
  region_vars = yamldecode(file(find_in_parent_folders("region-inputs.yaml")))
  env_vars    = yamldecode(file(find_in_parent_folders("env-inputs.yaml")))
  global_vars = yamldecode(file(find_in_parent_folders("global-inputs.yaml")))

  local_tags  = jsondecode(file("./local-tags.json"))
  spoke_tags  = jsondecode(file(find_in_parent_folders("spoke-tags.json")))
  region_tags = jsondecode(file(find_in_parent_folders("region-tags.json")))
  env_tags    = jsondecode(file(find_in_parent_folders("env-tags.json")))
  global_tags = jsondecode(file(find_in_parent_folders("global-tags.json")))

  tags = merge(
    local.global_tags,
    local.env_tags,
    local.region_tags,
    local.spoke_tags,
    local.local_tags
  )
}

include "root" {
  path = find_in_parent_folders("{{ .RootFileName }}")
}

generate "provider-mongoatlas" {
  path      = "provider-mongoatlas.g.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "mongodbatlas" {
  assume_role {
    role_arn     = "${local.global_vars.mongodb_atlas.secrets.sts_role_arn}"
  }
  aws_access_key_id     = "${get_env("AWS_ACCESS_KEY_ID", "")}"
  aws_secret_access_key = "${get_env("AWS_SECRET_ACCESS_KEY", "")}"
  aws_session_token     = "${get_env("AWS_SESSION_TOKEN", "")}"
  secret_name           = "${local.global_vars.mongodb_atlas.secrets.name}"
  region                = "${local.global_vars.mongodb_atlas.secrets.region}"
  sts_endpoint          = "${local.global_vars.mongodb_atlas.secrets.sts_endpoint}"
}
EOF
}
{{ if .atlas_container }}
dependency "atlascontainer" {
  config_path = "{{ .atlas_container_path }}"
  #skip_outputs = true
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "destroy"]
  mock_outputs = {
    network_container_id         = "7834759375uigig"
    network_container_aws_region = "us-east-1"
    network_container_aws_vpc_id = "vpc-12345678901234"
  }
}
{{ end }}
{{ if .project }}
dependency "project" {
  config_path = "{{ .project_path }}"
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "destroy"]
  mock_outputs = {
    project_id = "8403958hjhhhtur"
  }
}
{{ end }}
{{ if .vpc }}
dependency "vpc" {
  config_path = "{{ .vpc_path }}"
  #skip_outputs = true
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "destroy"]
  mock_outputs = {
    database_subnet_group      = "vpc-network-hub-aaaa-000-usea1"
    database_subnet_group_name = "database_subnet_group_name"
    database_subnets = [
      "subnet-abcdef123456789",
      "subnet-abcdef123456781",
      "subnet-abcdef123456782",
    ]
    private_subnets = [
      "subnet-01234567890123456",
      "subnet-01234567890123457",
      "subnet-01234567890123458",
    ]
    intra_subnets = [
      "subnet-01234567890123456",
      "subnet-01234567890123457",
      "subnet-01234567890123458",
    ]
    vpc_id                      = "vpc-12345678901234"
    vpc_cidr_block = "1.0.0.0/8"
  }
}
{{ end }}
terraform {
  source = "{{ .sourceUrl }}"
}

inputs = {
  is_hub     = {{ .is_hub }}
  org        = local.env_vars.org
  spoke_def  = local.spoke_vars.spoke
  {{- range .requiredVariables }}
  {{- if ne .Name "org" }}
  {{- if and $.atlas_container (eq .Name "atlas_container_id") }}
  {{ .Name }} = dependency.atlascontainer.outputs.network_container_id
  {{- else }}
  {{ .Name }} = local.local_vars.{{ .Name }}
  {{- end }}
  {{- end }}
  {{- end }}
  {{- range .optionalVariables }}
  {{- if not (eq .Name "extra_tags" "is_hub" "spoke_def" "org") }}
  {{- if and $.project (eq .Name "project_id") }}
  {{ .Name }} = dependency.project.outputs.project_id
  {{- else if and $.vpc (eq .Name "vpc") }}
  {{ .Name }} = {
  vpc_id         = dependency.vpc.outputs.vpc_id
    vpc_cidr_block = dependency.vpc.outputs.vpc_cidr_block
    {{- if eq $.vpc_subnet_selection "database" }}
    subnet_ids = dependency.vpc.outputs.database_subnets
    {{- else if eq $.vpc_subnet_selection "private" }}
    subnet_ids = dependency.vpc.outputs.private_subnets
    {{- else if eq $.vpc_subnet_selection "intra" }}
    subnet_ids = dependency.vpc.outputs.intra_subnets
    {{- end }}
  }
  {{- else }}
  {{ .Name }} = try(local.local_vars.{{ .Name }}, {{ .DefaultValue }})
  {{- end }}
  {{- end }}
  {{- end }}
  extra_tags = local.tags
}