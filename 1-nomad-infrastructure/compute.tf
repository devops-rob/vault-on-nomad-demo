data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "ssh" {
  vpc_id = module.vpc.vpc_id
  name   = "allow_ssh"

  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "nomad" {
  vpc_id = module.vpc.vpc_id
  name   = "nomad_port"

  ingress {
    from_port = 4646
    protocol  = "tcp"
    to_port   = 4648

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "allow_ssh"
  }
}


resource "aws_security_group" "egress" {
  vpc_id = module.vpc.vpc_id
  name   = "egress"

  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "vault" {
  vpc_id = module.vpc.vpc_id
  name   = "vault"

  ingress {
    from_port = 8200
    protocol  = "tcp"
    to_port   = 8201

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "vault"
  }
}


resource "aws_eip" "nomad_server" {
  tags = {
    Name = "Nomad Server"
  }
}

resource "aws_eip_association" "nomad_server" {
  instance_id   = aws_instance.nomad_servers.id
  allocation_id = aws_eip.nomad_server.id
}

resource "aws_instance" "nomad_servers" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnets.0
  key_name      = aws_key_pair.deployer.key_name


  user_data = templatefile("${path.cwd}/templates/servers.sh", {
    NOMAD_SERVER_TAG     = "true"
    NOMAD_SERVER_TAG_KEY = "nomad_server"
    NOMAD_SERVER_COUNT   = 1
    NOMAD_ADDR           = aws_eip.nomad_server.public_ip
  })

  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.egress.id,
    aws_security_group.nomad.id
  ]

  lifecycle {
    ignore_changes = [
      user_data,
      ami
    ]
  }

  tags = {
    Name         = "Nomad Server"
    nomad_server = true
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.ssh_key)
}

resource "aws_instance" "nomad_clients" {
  count                       = 3
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  subnet_id                   = module.vpc.public_subnets.0
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  user_data = templatefile("${path.cwd}/templates/clients.sh", {
    NOMAD_SERVERS_ADDR = "${aws_instance.nomad_servers.private_ip}"
  })

  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.egress.id,
    aws_security_group.nomad.id,
    aws_security_group.vault.id
  ]

  tags = {
    Name         = "Vault on Nomad Client ${count.index + 1}"
    nomad_server = false
  }

  lifecycle {
    ignore_changes = [
      user_data,
      ami
    ]
  }

  depends_on = [
    terracurl_request.nomad_status
  ]

}


resource "aws_instance" "nomad_clients_vault_backup" {
  count                       = 1
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  subnet_id                   = module.vpc.public_subnets.0
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  user_data = templatefile("${path.cwd}/templates/nomad-client-vault-backup.sh", {
    NOMAD_SERVERS_ADDR = "${aws_instance.nomad_servers.private_ip}"
  })

  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.egress.id,
    aws_security_group.nomad.id,
    aws_security_group.vault.id
  ]

  tags = {
    Name         = "Vault backup server"
    nomad_server = false
  }

  lifecycle {
    ignore_changes = [
      user_data,
      ami
    ]
  }

  depends_on = [
    terracurl_request.nomad_status
  ]

}

