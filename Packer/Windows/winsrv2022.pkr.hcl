packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "winsrv2K22" {

  node                        = "proxmoxB"
  os                          = "other"
  password                    = "ProjetAnnuel2023!"
  proxmox_url                 = "https://192.168.1.1:8006/api2/json"
  template_description        = "Windows Server 2022"
  username                    = "benjamin@pve"
  vm_name                     = "WinSrv2K22"
  cloud_init                  = true
  cloud_init_storage_pool     = "local-lvm"
  winrm_host                  = "WinSrv2K22"
  winrm_insecure              = true
  winrm_password              = "ProjetAnnuel2023!"
  winrm_use_ssl               = true
  winrm_username              = "Administrateur"
  winrm_port                  = "5986"
  winrm_timeout               = "30m"
  task_timeout                = "30m"
  insecure_skip_tls_verify    = true
  iso_file                    = "local:iso/winsrv-2022.iso"
  memory                      = 4096
  communicator                = "winrm"
  cores                       = "4"
  scsi_controller             = "virtio-scsi-single"
  bios                        = "ovmf"
  machine                     = "q35"
  qemu_agent                  = true
  boot                        = "order=ide2;scsi0"
  boot_wait = "8s"
  boot_command = [
    "<enter>"
  ]

  efi_config {
    efi_storage_pool= "local-lvm"
    pre_enrolled_keys= true
    efi_type= "4m"
  }
  
  additional_iso_files {
    device            = "sata3"
    iso_storage_pool  = "local"
    iso_file          = "local:iso/Autounattend.iso"
    unmount           = true
  }

  additional_iso_files {
    device            = "sata4"
    iso_storage_pool  = "local"
    iso_file          = "local:iso/virtio-win-0.1.229.iso"
    unmount           = true
  }

  additional_iso_files {
    device            = "sata5"
    iso_storage_pool  = "local"
    iso_file          = "local:iso/cloudbase-init.iso"
    unmount           = true
  }

  disks {
    disk_size         = "50G"
    storage_pool      = "local-lvm"
    type              = "scsi"
  }

  network_adapters {
    bridge   = "vmbr0"
    model    = "e1000"
  }

}

build {
  sources = ["source.proxmox-iso.winsrv2K22"]

  provisioner "powershell" {
    elevated_password = "ProjetAnnuel2023!"
    elevated_user     = "Administrateur"
    scripts           = ["./sysprep/cloudbase-init.ps1"]
  }

  provisioner "powershell" {
    elevated_password = "ProjetAnnuel2023!"
    elevated_user     = "Administrateur"
    pause_before      = "1m0s"
    scripts           = ["./sysprep/cloudbase-init-p2.ps1"]
  }

  provisioner "ansible" {
    playbook_file   = "${path.root}/Ansible/playbooks/sequences.yml"
    user            = "Administrateur"
    use_proxy       = false
    extra_arguments = [
      "-e",
      "ansible_winrm_server_cert_validation=ignore"
    ]
  }
}

// "provisioners": [
//     {
//         "type": "ansible",
//         "playbook_file": "src/playbook.yml",
//         "ansible_env_vars": [ 
//           "ANSIBLE_CONFIG=src/ansible.cfg"
//         ],
//         "extra_arguments": [
//             "-vvv",
//             "--extra-vars", 
//             "'variable={{ user `variable` }} ..... '" 
//         ]
//     }
// ],