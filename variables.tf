variable "tools" {
  default = {

    vault = {
      port          = 8200
      volume_size   = 20
      instance_type = "t3.small"
    }

  }
}

variable "zone_id" {
  default = "Z08641142SH8HBQE1FAJT"
}

variable "domain_name" {
  default = "sbakkolla.online"
}

