terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.30.0"
    }
  }
}

provider "linode" {
  token = "[YOUR TOKEN]"
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
  root_pass = "[YOUR PASSWORD]"
  backups_enabled = false
  private_ip = true
  tags = ["kasm"]
  stackscript_id = linode_stackscript.kasm-stackscript.id
}

output "public_ip" {
  value = linode_instance.kasm.ip_address
}

/*
sudo docker exec -i kasm_db psql -U kasmapp -d kasm <<EOF
    update users set
    pw_hash = 'fe519184b60a4ef9b93664a831502578499554338fd4500926996ca78fc7f522',
    salt = '83d0947a-bf55-4bec-893b-63aed487a05e',
    secret=NULL, set_two_factor=False, locked=False,
    disabled=False, failed_pw_attempts = 0 where username ='admin@kasm.local';
\q
EOF

------
Login:
- Your email   : "admin@kasm.local"
- Your password: "password"
*/