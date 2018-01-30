# S3 bucket: If you are using the S3 backend for remote state storage and the bucket you specify 
# in remote_state.config doesn't already exist, Terragrunt will create it automatically, with versioning enabled.

terragrunt = {
  remote_state {
    backend = "s3"
    config {
      region = "us-east-1"
      bucket = "${get_env("PROJECT", "")}-tfstate"
      encrypt = true
      key = "${path_relative_to_include()}/terraform.tfstate"
      dynamodb_table = "${get_env("PROJECT", "")}"
    }
  }
}

