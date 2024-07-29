locals {
  env         = "demo"
  platform    = "aws"
  app         = "copperleaf"
  cost-centre = "customer-demo"

  tags = {
    Environment = "demo"
    Project     = "webapp"
  }
}