# ---------------------------------------------------------------------------------------------------------------------
# OSS bucket
# ---------------------------------------------------------------------------------------------------------------------
# bucket format: acl:storage_class:stack-environment

resource "alicloud_oss_bucket" "oss"{
  count         = length(var.oss_buckets)
  bucket        = "${element(split(":",element(var.oss_buckets, count.index)),2)}"
  acl           = element(split(":",element(var.oss_buckets, count.index)),0)
  storage_class = element(split(":",element(var.oss_buckets, count.index)),1)
  tags = {
    role = "bucket"
    Environment = element(split(".",element(split(":",element(var.oss_buckets, count.index)),2)),1)
    stack = element(split(".",element(split(":",element(var.oss_buckets, count.index)),2)),0)
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# OSS policy
# ---------------------------------------------------------------------------------------------------------------------
# format: bucket:fullaccess, bucket/folder:readonly

resource "alicloud_ram_policy" "oss-policy" {
  count    = length(var.oss_access)
  name     = replace(replace(element(var.oss_access, count.index),"/","-"),":","_")
  document = <<EOF
  {
    "Statement": [
      {
        "Action": {
           "value": ${jsonencode(element(split(":",element(var.oss_access, count.index)),1) == "fullaccess" ? var.fullaccess : var.readonly)}
        },
        "Effect": "Allow",
        "Resource": [
          "acs:oss:*:*:${element(split("/",element(split(":",element(var.oss_access, count.index)),0)),0)}",
          "acs:oss:*:*:${element(split(":",element(var.oss_access, count.index)),0)}/*"
        ]
      }
    ],
    "Version": "1"
  }
  EOF
  description = "${element(split(":",element(var.oss_access, count.index)),1)} access for oss ${element(split(":",element(var.oss_access, count.index)),0)}"
}

# ---------------------------------------------------------------------------------------------------------------------
# OSS ram user
# ---------------------------------------------------------------------------------------------------------------------
resource "alicloud_ram_user" "oss-ram_users" {
  count        = length(var.oss_access)
  name         = replace(replace(element(var.oss_access, count.index),"/","-"),":","_")
  display_name = replace(replace(element(var.oss_access, count.index),"/","-"),":","_")
}

# ---------------------------------------------------------------------------------------------------------------------
# OSS ram user access key
# ---------------------------------------------------------------------------------------------------------------------
resource "alicloud_ram_access_key" "oss-access_keys" {
  count       = length(var.oss_access)
  user_name   = replace(replace(element(var.oss_access, count.index),"/","-"),":","_")
  secret_file = "./secrets-${replace(replace(element(var.oss_access, count.index),"/","-"),":","_")}"
}


# ---------------------------------------------------------------------------------------------------------------------
# OSS ram user attach policy
# ---------------------------------------------------------------------------------------------------------------------
resource "alicloud_ram_user_policy_attachment" "oss-attaches" {
  count       = length(var.oss_access)
  policy_name = replace(replace(element(var.oss_access, count.index),"/","-"),":","_")
  policy_type = "Custom"
  user_name   = replace(replace(element(var.oss_access, count.index),"/","-"),":","_")
}
