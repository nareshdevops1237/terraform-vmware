terraform {
  required_version = ">= 1.6.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

locals {
  vm_dir    = "${var.vm_root_path}/${var.vm_name}"
  vmx_path  = "${local.vm_dir}/${var.vm_name}.vmx"
  vmdk_path = "${local.vm_dir}/${var.vm_name}.vmdk"

  disk_size   = "${var.disk_size_gb}GB"
  iso_present = var.attach_iso ? "TRUE" : "FALSE"
}

resource "terraform_data" "create_vm_folder_and_disk" {
  input = {
    vm_dir            = local.vm_dir
    vmdk_path         = local.vmdk_path
    disk_size         = local.disk_size
    vdiskmanager_path = var.vdiskmanager_path
    iso_path          = var.iso_path
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

    command = <<-EOT
      $vmDir = "${self.input.vm_dir}"
      $vmdk = "${self.input.vmdk_path}"
      $diskSize = "${self.input.disk_size}"
      $vdiskmanager = "${self.input.vdiskmanager_path}"
      $iso = "${self.input.iso_path}"

      if (!(Test-Path $vdiskmanager)) {
        throw "vmware-vdiskmanager.exe not found at: $vdiskmanager"
      }

      if (!(Test-Path $iso)) {
        throw "ISO file not found at: $iso"
      }

      New-Item -ItemType Directory -Force -Path $vmDir | Out-Null

      if (!(Test-Path $vmdk)) {
        Write-Host "Creating VMware virtual disk: $vmdk"
        & $vdiskmanager -c -s $diskSize -a lsilogic -t 0 $vmdk
      } else {
        Write-Host "Virtual disk already exists: $vmdk"
      }
    EOT
  }
}

resource "local_file" "vmx" {
  depends_on = [
    terraform_data.create_vm_folder_and_disk
  ]

  filename = local.vmx_path

  content = <<-EOF
.encoding = "windows-1252"
config.version = "8"
virtualHW.version = "20"

displayName = "${var.vm_name}"
guestOS = "${var.guest_os}"

memsize = "${var.memory_mb}"
numvcpus = "${var.cpu_count}"
cpuid.coresPerSocket = "${var.cpu_count}"

firmware = "efi"
uefi.secureBoot.enabled = "FALSE"

scsi0.present = "TRUE"
scsi0.virtualDev = "lsilogic"

scsi0:0.present = "TRUE"
scsi0:0.fileName = "${var.vm_name}.vmdk"

ide1:0.present = "${local.iso_present}"
ide1:0.fileName = "${var.iso_path}"
ide1:0.deviceType = "cdrom-image"
ide1:0.startConnected = "${local.iso_present}"

ethernet0.present = "TRUE"
ethernet0.connectionType = "${var.network_type}"
ethernet0.virtualDev = "e1000e"
ethernet0.addressType = "generated"

usb.present = "TRUE"
sound.present = "FALSE"

tools.syncTime = "TRUE"

checkpoint.vmState = ""
EOF
}

resource "terraform_data" "start_vm" {
  depends_on = [
    local_file.vmx
  ]

  input = {
    vmx_path   = local.vmx_path
    vmrun_path = var.vmrun_path
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

    command = <<-EOT
      $vmx = "${self.input.vmx_path}"
      $vmrun = "${self.input.vmrun_path}"

      if (!(Test-Path $vmrun)) {
        throw "vmrun.exe not found at: $vmrun"
      }

      if (!(Test-Path $vmx)) {
        throw "VMX file not found at: $vmx"
      }

      Write-Host "Starting VM: $vmx"
      & $vmrun -T ws start $vmx gui
    EOT
  }
}