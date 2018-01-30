terragrunt = {
  include = {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "../../..//modules/dns_zone"

    extra_arguments "conditional_vars" {
      commands = [
        "apply",
        "plan",
        "destroy",
        "import",
        "push",
        "refresh"
      ]

      optional_var_files = [
        "${get_tfvars_dir()}/../../../../global.tfvars",
        "${get_tfvars_dir()}/../../../provider.tfvars",
        "${get_tfvars_dir()}/../../environment.tfvars",
        "${get_tfvars_dir()}/../region.tfvars",
      ]
    }
  }
}
