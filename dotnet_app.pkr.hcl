packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "dotnet-app" {
  ami_name       = "dotnet-app-${local.timestamp}"
  communicator   = "winrm"
  instance_type  = "t3.micro"
  region         = "${var.region}"
  source_ami     = "ami-02a40ef7aa50d9774"
  winrm_password = "SuperS3cr3t!!!!"
  winrm_username = "Administrator"
  access_key = "<access_key>"
  secret_key = "<secret_key>"
}

build {
  name    = "dotnet_app"
  sources = ["source.amazon-ebs.dotnet-app"]

  provisioner "powershell" {
    inline  = ["mkdir C:\\workspace",
                "cd C:\\workspace",
                "git clone https://github.com/steffan11001/aspnetcoreapp.git",
                "cd aspnetcoreapp",
                "dotnet publish -c Release -o out",
                "Start-Job -ScriptBlock {& \"C:\\Program Files\\dotnet\\dotnet.exe\" \"out\\aspnetcoreapp.dll\"}"]
  }
}


