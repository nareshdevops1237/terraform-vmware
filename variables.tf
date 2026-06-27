variable "vm_name" {
  description = "Name of the VMware Workstation VM"
  type        = string
  default     = "ubuntu-lab-01"
}

variable "vm_root_path" {
  description = "Root folder where VMware VMs will be stored"
  type        = string
  default     = "C:/VMware-Labs"
}

variable "iso_path" {
  description = "Full path of the ISO image"
  type        = string
}

variable "memory_mb" {
  description = "Memory in MB"
  type        = number
  default     = 4096
}

variable "cpu_count" {
  description = "Number of vCPUs"
  type        = number
  default     = 2
}

variable "disk_size_gb" {
  description = "Virtual disk size in GB"
  type        = number
  default     = 60
}

variable "guest_os" {
  description = "VMware guest OS type"
  type        = string
  default     = "ubuntu-64"
}

variable "network_type" {
  description = "VMware network type: nat or bridged"
  type        = string
  default     = "nat"

  validation {
    condition     = contains(["nat", "bridged"], var.network_type)
    error_message = "network_type must be nat or bridged."
  }
}

variable "vmrun_path" {
  description = "Path to vmrun.exe"
  type        = string
  default     = "C:/Program Files (x86)/VMware/VMware Workstation/vmrun.exe"
}

variable "vdiskmanager_path" {
  description = "Path to vmware-vdiskmanager.exe"
  type        = string
  default     = "C:/Program Files (x86)/VMware/VMware Workstation/vmware-vdiskmanager.exe"
}

variable "attach_iso" {
  description = "Attach ISO to VM"
  type        = bool
  default     = true
}