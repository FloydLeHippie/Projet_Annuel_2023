terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.7.4"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.1.1:8006/api2/json"
  pm_tls_insecure = true
  pm_user = var.pm_user
  pm_password = var.pm_password
}

resource "proxmox_vm_qemu" "SRV-FAVB-TEST" {
  name = "SRV-FAVB-TEST"
  target_node = "proxmoxB"
  agent = 1
  qemu_os = "other"
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  boot = "order=scsi0"
  bootdisk = "scsi0"
  clone = "WinSrv2K22"
  ipconfig0 = "ip=192.168.1.151/24,gw=192.168.1.254"
  nameserver = "192.168.1.254"
  bios = "ovmf"
  
  network {
    model = "e1000"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      disk,
    ]
  }  
}

# resource "proxmox_vm_qemu" "SRV-FAVB-2" {
#   name = "SRV-FAVB-2"
#   target_node = "proxmoxB"
#   agent = 1
#   qemu_os = "other"
#   os_type = "cloud-init"
#   cores = 2
#   sockets = 1
#   cpu = "host"
#   memory = 4096
#   scsihw = "virtio-scsi-pci"
#   boot = "order=scsi0"
#   bootdisk = "scsi0"
#   clone = "WinSrv2K22"
#   ipconfig0 = "ip=192.168.1.152/24,gw=192.168.1.254"
#   nameserver = "192.168.1.254"
#   bios = "ovmf"
  
#   network {
#     model = "e1000"
#     bridge = "vmbr0"
#   }

#   lifecycle {
#     ignore_changes = [
#       disk,
#     ]
#   }  
# }