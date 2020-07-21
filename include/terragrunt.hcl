include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "git@github.com:quid/module-ali-oss.git//module?ref=v0.1.0"
}

inputs = {
  oss_buckets = [
    "private:Standard:annotations.dev.quidops.com"
  ],
  oss_access = [
    "annotations.dev.quidops.com:fullaccess"
  ]
}
