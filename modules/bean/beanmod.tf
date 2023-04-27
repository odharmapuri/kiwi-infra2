provider "aws" {
  region = "us-west-2"
}

module "beanstalk" {
  source                          = "terraform-aws-modules/elastic-beanstalk/aws"
  version                         = "~> 2.0"
  name                            = "my-beanstalk-app"
  environment_name                = "my-beanstalk-env"
  solution_stack_name             = "64bit Amazon Linux 2018.03 v4.7.1 running Ruby 2.6"
  application_port                = "3000"
  healthcheck_url                 = "/"
  instance_type                   = "t3.micro"
  min_instances                   = 2
  max_instances                   = 4
  enable_rolling_update           = true
  rolling_update_min_in_service   = 1
  rolling_update_max_batch_size   = 2
  rolling_update_pause_time       = "PT10M"
  description                     = "My Elastic Beanstalk Environment"
  tags                            = {
    Environment = "dev"
    Department  = "Engineering"
  }
}


#with Genie

provider "aws" {
  region = "us-west-2"
}

module "elastic_beanstalk" {
  source       = "terraform-aws-modules/elastic-beanstalk/aws"
  version      = "3.0.0"
  name         = "example-app"
  environment  = "dev"
  solution_stack_name = "64bit Amazon Linux 2 v4.1.0 running Python 3.8"
  
  # Application Settings
  force_destroy_app = true
  app_name           = "example-app"
  description        = "Example Elastic Beanstalk application"

  # Environment Configuration
  instance_type             = "t2.small"
  health_check_type         = "EC2"
  min_instances             = 1
  max_instances             = 3
  autoscale_min_size        = 1
  autoscale_max_size        = 3
  rolling_deploy_enabled    = true

  # VPC Configuration
  vpc_id                     = "vpc-12345678"
  subnet_ids                 = ["subnet-12345678", "subnet-23456789"]
  associate_public_ip_address= true
}


############################
provider "aws" {
  region = "us-west-2"
}

module "elastic_beanstalk" {
  source  = "terraform-aws-modules/elastic-beanstalk/aws"
  version = "3.0.0"

  name        = "my-app"
  description = "My Elastic Beanstalk application"

  # Elastic Beanstalk environment settings
  solution_stack_name         = "64bit Amazon Linux 2 v5.4.3 running Ruby 2.7"
  instance_type               = "t2.micro"
  min_instances               = 1
  max_instances               = 2
  rolling_update_enabled      = true
  rolling_update_type         = "Time"
  rolling_update_batch_size   = 1
  rolling_update_pause_time   = 0
  healthcheck_url             = "/"
  healthcheck_success_codes   = "200"
  enable_managed_actions      = true

  # Load balancer settings
  associate_public_ip_address = false
  load_balancer_type          = "application"
  load_balancer_subnets       = ["subnet-12345678"]

  # Security group settings
  security_groups = ["sg-12345678"]

  # Application settings (optional)
  app_version_lifecycle = {
    delete_source_from_s3 = true
  }
}
####################################################


###################################################
