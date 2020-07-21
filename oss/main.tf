# ---------------------------------------------------------------------------------------------------------------------
# OSS bucket
# ---------------------------------------------------------------------------------------------------------------------
# bucket format: acl:storage_class:stack-environment

resource "alicloud_oss_bucket" "oss"{
  count    = length(var.oss_buckets)
  bucket   = element(split(":",element(var.oss_buckets, count.index)),2)
  acl = element(split(":",element(var.oss_buckets, count.index)),0)
  storage_class = element(split(":",element(var.oss_buckets, count.index)),1)
  tags = {
    role = "bucket"
    Environment = element(split("-",element(split(":",element(var.oss_buckets, count.index)),2)),1)
    stack = element(split("-",element(split(":",element(var.oss_buckets, count.index)),2)),0)
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# OSS policy
# ---------------------------------------------------------------------------------------------------------------------
# format: bucket:fullaccess, bucket/folder:readonly

resource "alicloud_ram_policy" "oss-fullaccess_policy" {
  count    = length(var.oss_fullaccess_policy)
  name     = element(split(":",replace(element(var.oss_fullaccess_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
  document = <<EOF
  {
    "Statement": [
      {
        "Action": [
          "oss:ListBuckets",
          "oss:GetObject",
          "oss:PutObject",
          "oss:DeleteObject",
          "oss:ListParts",
          "oss:AbortMultipartUpload",
          "oss:ListObjects"
        ],
        "Effect": "Allow",
        "Resource": [
          "acs:oss:*:*:".element(split("/",element(split(":",element(var.oss_fullaccess_policy, count.index)),0)),0),
          "acs:oss:*:*:".element(split(":",element(var.oss_fullaccess_policy, count.index)),0)."/*"
        ]
      }
    ],
      "Version": "1"
  }
  EOF
  description = "read/write access for oss ".element(split(":",element(var.oss_fullaccess_policy, count.index)),0)
}

resource "alicloud_ram_policy" "oss-readonly_policy" {
  count    = length(var.oss_readonly_policy)
  name     = element(split(":",replace(element(var.oss_readonly_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
  document = <<EOF
  {
    "Statement": [
      {
        "Action": [
          "oss:List*",
          "oss:Get*"
        ],
        "Effect": "Allow",
        "Resource": [
          "acs:oss:*:*:".element(split("/",element(split(":",element(var.oss_readonly_policy, count.index)),0)),0),
          "acs:oss:*:*:".element(split(":",element(var.oss_readonly_policy, count.index)),0)."/*"
        ]
      }
    ],
      "Version": "1"
  }
  EOF
  description = "readonly access for oss ".element(split(":",element(var.oss_readonly_policy, count.index)),0)
}

# ---------------------------------------------------------------------------------------------------------------------
# OSS ram user
# ---------------------------------------------------------------------------------------------------------------------
resource "alicloud_ram_user" "oss-fullaccess-ram_users" {
  count        = length(var.oss_fullaccess_policy)
  name         = element(split(":",replace(element(var.oss_fullaccess_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
  dispaly_name = element(split(":",replace(element(var.oss_fullaccess_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
}

resource "alicloud_ram_user" "oss-readonly-ram_users" {
  count        = length(var.oss_readonly_policy)
  name         = element(split(":",replace(element(var.oss_readonly_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
  dispaly_name = element(split(":",replace(element(var.oss_readonly_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
}

# ---------------------------------------------------------------------------------------------------------------------
# OSS ram user access key
# ---------------------------------------------------------------------------------------------------------------------
resource "alicloud_ram_access_key" "oss-fullaccess-access_keys" {
  user_name   = element(split(":",replace(element(var.oss_fullaccess_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
  secret_file = "./secrets-".element(split(":",replace(element(var.oss_fullaccess_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
}

resource "alicloud_ram_access_key" "oss-readonly-access_keys" {
  user_name   = element(split(":",replace(element(var.oss_readonly_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
  secret_file = "./secrets-".element(split(":",replace(element(var.oss_readonly_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
}

# ---------------------------------------------------------------------------------------------------------------------
# OSS ram user attach policy
# ---------------------------------------------------------------------------------------------------------------------
resource "alicloud_ram_user_policy_attachment" "oss-fullaccess-attaches" {
  count        = length(var.oss_fullaccess_policy)
  policy_name  = element(split(":",replace(element(var.oss_fullaccess_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
  policy_type  = "Custom"
  user_name    = element(split(":",replace(element(var.oss_fullaccess_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
}

resource "alicloud_ram_user_policy_attachment" "oss-readonly-attaches" {
  count        = length(var.oss_readonly_policy)
  policy_name  = element(split(":",replace(element(var.oss_readonly_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
  policy_type  = "Custom"
  user_name    = element(split(":",replace(element(var.oss_readonly_policy, count.index),"/",".")),0)."_".element(split(":",element(var.oss_buckets, count.index)),1))
}
