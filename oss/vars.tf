variable "oss_buckets" {
  description = "oss buckets"
  type        = list(string)
}

variable "oss_access" {
  description = "policy for oss buckets"
  type        = list(string)
}

variable "fullaccess" {
  description = "fullaccess action for ram_policy"
  type        = list(string)
  default =  [
               "oss:ListBuckets",
               "oss:GetObject",
               "oss:PutObject",
               "oss:DeleteObject",
               "oss:ListParts",
               "oss:AbortMultipartUpload",
               "oss:ListObjects"
             ]
}

variable "readonly" {
  description = "readonly action for ram_policy"
  type        = list(string)
  default = [
              "oss:List*",
              "oss:Get*"
            ]
}
