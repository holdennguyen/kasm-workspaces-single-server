terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.30.0"
    }
  }
}

provider "linode" {
  token = "[YOUR TOKEN]" //Replace by your Linode Personal Access Token here
}

resource "linode_stackscript" "kasm-stackscript" {
  label      = "kasm"
  description = "Kasm StackScript"
  is_public  = false
  script     = file("./script.sh")
  images        = ["linode/ubuntu20.04"]
}

resource "linode_instance" "kasm" {
  label = "kasm"
  type = "g6-standard-2"
  region = "us-east"
  image = "linode/ubuntu20.04"
  root_pass = "[YOUR PASSWORD]" //Provide you own password here
  backups_enabled = false
  private_ip = true
  tags = ["kasm"]
  stackscript_id = linode_stackscript.kasm-stackscript.id
}

output "public_ip" {
  value = linode_instance.kasm.ip_address
}