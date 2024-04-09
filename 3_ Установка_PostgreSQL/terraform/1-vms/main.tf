terraform {
  required_providers {
    yandex = {
      source = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
}

variable "postgres_server_name" {
  type    = list(any)
  default = ["postgres-1"]
}

variable "postgres_server_ip" {
  type    = list(any)
  default = ["192.168.137.10"]
}

# username пользователя на создаваемом сервере
variable "host_user" {
  default = "ubuntu"
}

variable "ssh_public_key_file" {
  default = "~/.ssh/otus_id_rsa.pub"
}
variable "ssh_private_key_file" {
  default = "~/.ssh/otus_id_rsa"
}

data "yandex_compute_image" "container-optimized-image" {
  family = "ubuntu-2204-lts"
}

resource "yandex_vpc_network" "lab-net" {
  name = "lab-network"
}

resource "yandex_vpc_subnet" "lab-subnet-a" {
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.lab-net.id}"
  v4_cidr_blocks = ["192.168.137.0/24"]
}

resource "yandex_compute_instance" "postgres" {
  count       = length(var.postgres_server_name)
  name        = element(var.postgres_server_name, count.index)
  hostname    = element(var.postgres_server_name, count.index)
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores         = 2 # 2, 4, 6, 8 ...
    memory        = 6
    core_fraction = "20" # 20, 50 100
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    auto_delete = "true"
    initialize_params {
      image_id = "${data.yandex_compute_image.container-optimized-image.id}"
      size     = 10
      type     = "network-ssd"
    }

  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.lab-subnet-a.id}"
    nat        = "true"
    ip_address = element(var.postgres_server_ip, count.index)
  }

  metadata = {
    ssh-keys           = "var.host_user:${file(var.ssh_public_key_file)}"
    serial-port-enable = 1
  }

}






### The inventory file
resource "local_file" "ansibleInventory" {
  depends_on = [yandex_compute_instance.postgres]
  content = templatefile("invetory.tpl",
    {
      postgres_name         = yandex_compute_instance.postgres[*].name,
      postgres_ipv4-address = yandex_compute_instance.postgres[*].network_interface[0].nat_ip_address,
      ssh_key               = var.ssh_private_key_file,
      host_user             = var.host_user
    }
  )
  filename = "otus-hosts.txt"
}

output "yandex_compute_instance_postgres_nat_ip_address" {
  value = yandex_compute_instance.postgres[*].network_interface[0].nat_ip_address
}

output "yandex_compute_instance_postgres_internal_ip_address" {
  value = yandex_compute_instance.postgres[*].network_interface[0].ip_address
}



