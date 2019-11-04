variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "sachin-linux"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "sachin-linux.pub"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-0cdc271d99924feda"
    us-west-2 = "ami-0db09247c9ffdd80c"
    ap-south-1 = "ami-0dc730d9dc3f3da92"
  }
}

variable "INSTANCE_DEVICE_NAME" {
  default = "/dev/xvdz"
}
variable "AWS_SECRET_KEY" {}
variable "AWS_ACCESS_KEY" {}
