provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  #shared_credentials_files = ["/Users/rwagh/.aws/credentials"]
}
#Modules
module "vpc" {
  source  = "./modules/vpc"
  zone1a  = var.zone1a
  zone1b  = var.zone1b
  project = var.project
}
module "ec2" {
  source     = "./modules/ec2"
  sn1        = module.vpc.sn1
  sn2        = module.vpc.sn2
  app-sg     = module.vpc.app-sg
  alb-sg     = module.vpc.alb-sg
  backend-sg = module.vpc.backend-sg
  project    = var.project
  centos     = var.centos
  key-pair   = var.key-pair
}
module "alb" {
  source  = "./modules/alb"
  project = var.project
  vpc-id  = module.vpc.vpc-id
  count   = length(module.ec2.app)
  app     = element(module.ec2.app, count.index)
  alb-sg = module.vpc.alb-sg
  sn1    = module.vpc.sn1
  sn2    = module.vpc.sn2
}
/*module "s3" {
  source  = "./modules/s3"
  project = var.project
}
module "asg" {
  source   = "./modules/asg"
  project  = var.project
  app-sg   = module.vpc.app-sg
  sn1      = module.vpc.sn1
  sn2      = module.vpc.sn2
  tg       = module.alb[*].tg
  aws-alb  = module.alb[*].aws-alb
  key-pair = var.key-pair
}*/
module "route53" {
  source = "./modules/route53"
  vpc-id = module.vpc.vpc-id
  db     = module.ec2.db
  cache  = module.ec2.cache
  mq     = module.ec2.mq
}