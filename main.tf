terraform {
  required_version = ">= 1.5.0"

  required_providers {
    vmwareworkstation = {
      source  = "hashicorp/vmwareworkstation"
      version = "~> 1.0"
    }
  }
}

provider "vmwareworkstation" {}

resource "vmwareworkstation_virtual_machine" "example" {
  name      = var.vm_name
  memory    = var.memory_mb
  cpus      = var.cpu_count
  disk_size = var.disk_size_gb
  network   = var.network_type
  iso_path  = var.iso_path
  guest_os  = var.guest_os
}
