# AliCloud OSS Module

Version: v0.1.0

## How to use

- create oss bucket
  - bucket policy:storage_class:bucket name
  - The bucket name cannot start or end with a hyphen (-). It can contain only lowercase letters, digits, and hyphens (-).
```
  oss_buckets = [
    "private:Standard:annotations.dev.quidops.com"
  ]
```
- create ram user to access oss bucket
  - bucket nmae:access policy
  - bucket name can be the folder under bucket
  - access policy currently only support fullaccess and readonly
```
  oss_access = [
    "annotations.dev.quidops.com:fullaccess",
    "annotations.dev.quidops.com/test_folder:readonly"
  ]
```
## reference
- [oss_bucket](https://www.terraform.io/docs/providers/alicloud/r/oss_bucket.html)
