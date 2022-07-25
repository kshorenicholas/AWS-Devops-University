/*variable "password"{
  type = string
 }

variable "host"{
} */

variable "ami" {
  description = "ami value for the cloud system"
  type        = map(string)
  default = {
    ubuntu_focal         = "ami-0e91c34d3c7ee6fae"
    win_server_2019_base = "ami-0f9a92942448ac56f"
    rhel8                = "ami-0b0af3577fe5e3532"
    debian_10            = "ami-07d02ee1eeb0c996c"
    kali                 = "ami-01691107cfcbce68c"
  }
}

variable "machine_number" {
  description = "number of virtual machines to deploy"
  # type = number
  default = 2
}

variable "ssh_user" {
  description = "SSH username to connect to the machine"
  default     = "ubuntu" //any name would do  
}

variable "public_key_path" {
  description = "path to the public SSH key for the machines"
  default     = "~/.ssh/trial.pub"
}

variable "private_key_path" {
  description = "path to the private SSH key to access the machine"
  default     = "~/.ssh/trial"
}

variable "ssh_port" {
  description = "The port the EC2 Instance should listen on for SSH requests."
  type        = number
  default     = 22
}

variable "ansible_location" {
  description = "path to ansible file for provisioning instances"
  default     = "../../ansible/software.yaml"
}