module "rds" {
  source = "git@github.com:quid/module-ali-db.git//module?ref=v0.1.2"

  stack            = "quidwebdb"
  role             = "rds"
  db_instance_type = "mysql.n1.micro.1"
}
