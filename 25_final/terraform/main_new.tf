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

variable "wordpress_db_name" {
  type    = list(any)
  default = ["postgres-1", "postgres-2"]
}

variable "wordpress_db_server_ip" {
  type    = list(any)
  default = ["192.168.137.52", "192.168.137.53"]
}

variable "wordpress_server_name" {
  type    = list(any)
  default = ["wordpress-app-1"]
}

variable "wordpress_server_ip" {
  type    = list(any)
  default = ["192.168.137.10"]
}

variable "zabbix_server_name" {
  type    = list(any)
  default = ["zabbix"]
}

variable "zabbix_server_ip" {
  type    = list(any)
  default = ["192.168.137.13"]
}

variable "elk_server_name" {
  type    = list(any)
  default = ["elk"]
}

variable "elk_server_ip" {
  type    = list(any)
  default = ["192.168.137.14"]
}

variable "jmeter_server_name" {
  type    = list(any)
  default = ["jmeter-1", "jmeter-2"]
}

variable "jmeter_server_ip" {
  type    = list(any)
  default = ["192.168.137.15", "192.168.137.16"]
}



# username пользователя на создаваемом сервере
variable "host_user" {
  default = "ubuntu"
}

variable "ssh_public_key_file" {
  default = "~/.ssh/rebrain_id_rsa.pub"
}
variable "ssh_private_key_file" {
  default = "~/.ssh/rebrain_id_rsa"
}

variable "image_id" {
  default = "fd8mfc6omiki5govl68h" # ubuntu 20.04
}

resource "yandex_vpc_network" "foo" {
  name = "lab-network"
}

resource "yandex_vpc_subnet" "foo" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.foo.id
  v4_cidr_blocks = ["192.168.137.0/24"]
}

# postgres
resource "yandex_compute_instance" "wordpress_db" {
  count       = length(var.wordpress_db_name)
  name        = element(var.wordpress_db_name, count.index)
  hostname    = element(var.wordpress_db_name, count.index)
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores         = 6
    memory        = 6
    core_fraction = "100"
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    auto_delete = "true"
    initialize_params {
      image_id = var.image_id
      size     = 10
      type     = "network-ssd"
    }

  }

  network_interface {
    subnet_id  = "yandex_vpc_subnet.foo.id"
    nat        = "true"
    ip_address = element(var.wordpress_db_server_ip, count.index)
  }

  metadata = {
    ssh-keys           = "var.host_user:${file(var.ssh_public_key_file)}"
    serial-port-enable = 1
  }

}




resource "yandex_compute_instance" "wordpress" {
  count       = length(var.wordpress_server_name)
  name        = element(var.wordpress_server_name, count.index)
  hostname    = element(var.wordpress_server_name, count.index)
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores         = 6
    memory        = 6
    core_fraction = "100"
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    auto_delete = "true"
    initialize_params {
      image_id = var.image_id
      size     = 10
      type     = "network-ssd"
    }

  }

  network_interface {
    subnet_id  = "yandex_vpc_subnet.foo.id"
    nat        = "true"
    ip_address = element(var.wordpress_server_ip, count.index)
  }

  metadata = {
    ssh-keys           = "var.host_user:${file(var.ssh_public_key_file)}"
    serial-port-enable = 1
  }

}

resource "yandex_compute_instance" "zabbix" {
  count       = length(var.zabbix_server_name)
  name        = element(var.zabbix_server_name, count.index)
  hostname    = element(var.zabbix_server_name, count.index)
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = "20"
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    auto_delete = "true"
    initialize_params {
      image_id = var.image_id
      size     = 10
      type     = "network-hdd"
    }

  }

  network_interface {
    subnet_id  = "yandex_vpc_subnet.foo.id"
    nat        = "true"
    ip_address = element(var.zabbix_server_ip, count.index)
  }

  metadata = {
    ssh-keys           = "var.host_user:${file(var.ssh_public_key_file)}"
    serial-port-enable = 1
  }

}

resource "yandex_compute_instance" "elk" {
  count       = length(var.elk_server_name)
  name        = element(var.elk_server_name, count.index)
  hostname    = element(var.elk_server_name, count.index)
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = "20"
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    auto_delete = "true"
    initialize_params {
      image_id = var.image_id
      size     = 10
      type     = "network-ssd"
    }

  }

  network_interface {
    subnet_id  = "yandex_vpc_subnet.foo.id"
    nat        = "true"
    ip_address = element(var.elk_server_ip, count.index)
  }

  metadata = {
    ssh-keys           = "var.host_user:${file(var.ssh_public_key_file)}"
    serial-port-enable = 1
  }

}


resource "yandex_compute_instance" "jmeter" {
  count       = length(var.jmeter_server_name)
  name        = element(var.jmeter_server_name, count.index)
  hostname    = element(var.jmeter_server_name, count.index)
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = "20"
  }

  scheduling_policy {
    preemptible = true
  }


  boot_disk {
    auto_delete = "true"
    initialize_params {
      image_id = var.image_id
      size     = 10
      type     = "network-hdd"
    }

  }

  network_interface {
    subnet_id  = "yandex_vpc_subnet.foo.id"
    nat        = "true"
    ip_address = element(var.jmeter_server_ip, count.index)
  }

  metadata = {
    ssh-keys           = "var.host_user:${file(var.ssh_public_key_file)}"
    serial-port-enable = 1
  }

}



### The inventory file
resource "local_file" "ansibleInventory" {
  depends_on = [yandex_compute_instance.wordpress]
  content = templatefile("invetory.tpl",
    {
      wordpress_db_name         = yandex_compute_instance.wordpress_db[*].name,
      wordpress_db_ipv4-address = yandex_compute_instance.wordpress_db[*].network_interface[0].nat_ip_address,
      wordpress_name            = yandex_compute_instance.wordpress[*].name,
      wordpress_ipv4-address    = yandex_compute_instance.wordpress[*].network_interface[0].nat_ip_address,
      zabbix_name               = yandex_compute_instance.zabbix[*].name,
      zabbix_ipv4-address       = yandex_compute_instance.zabbix[*].network_interface[0].nat_ip_address,
      elk_name                  = yandex_compute_instance.elk[*].name,
      elk_ipv4-address          = yandex_compute_instance.elk[*].network_interface[0].nat_ip_address,
      jmeter_name               = yandex_compute_instance.jmeter[*].name,
      jmeter_ipv4-address       = yandex_compute_instance.jmeter[*].network_interface[0].nat_ip_address,
      ssh_key                   = var.ssh_private_key_file,
      host_user                 = var.host_user
    }
  )
  filename = "../ansible/hl-hosts-new.txt"
}

output "yandex_compute_instance_wordpress_nat_ip_address" {
  value = yandex_compute_instance.wordpress[*].network_interface[0].nat_ip_address
}

output "yandex_compute_instance_wordpress_internal_ip_address" {
  value = yandex_compute_instance.wordpress[*].network_interface[0].ip_address
}



