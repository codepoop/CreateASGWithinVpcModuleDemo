##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################

data "aws_subnet_ids" "public" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Tier = "Public"
  }

}

data "aws_subnet_ids" "private" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Tier = "Private"
  }

}


data "aws_security_group" "default" {
  vpc_id = module.vpc.vpc_id
  name   = "default"
}


###############################################################
# Launch configuration and autoscaling group
###############################################################
module "example" {
  source = "./tf-module/asg/"
  name = "example-with-ec2"
  lc_name = "example-lc"
  image_id                     = var.AMIS[var.AWS_REGION]
  instance_type                = "t2.micro"
  security_groups              = [data.aws_security_group.default.id]
  associate_public_ip_address  = true
  recreate_asg_when_lc_changes = true
  key_name                     = aws_key_pair.mykeypair.key_name
  user_data                    = data.template_cloudinit_config.cloudinit-example.rendered
  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "8"
      delete_on_termination = true
    },
  ]
  root_block_device = [
    {
      volume_size           = "8"
      volume_type           = "gp2"
      delete_on_termination = true
    },
  ]

####### Auto scaling group ############
  asg_name                  = "example-asg"
  vpc_zone_identifier       = data.aws_subnet_ids.public.ids
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "SomeShit"
      propagate_at_launch = true
    },
  ]

  tags_as_map = {
    extra_tag1 = "extra_value1"
    extra_tag2 = "extra_value2"
  }
}
