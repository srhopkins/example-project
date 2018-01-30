terragrunt = {
  include = {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "git::ssh://git@gitlab.disney.com/tf-modules/iam_roles.git//dba-masters?ref=0.2.1"

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
