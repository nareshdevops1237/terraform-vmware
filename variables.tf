variable "vm_name" {
  description = "Name of the VMware Workstation virtual machine"
  type        = string
  default     = "terraform-vm"
}

variable "memory_mb" {
  description = "Amount of RAM in megabytes"
  type        = number
  default     = 2048
}

variable "cpu_count" {
  description = "Number of virtual CPUs"
  type        = number
  default     = 2
}

variable "disk_size_gb" {
  description = "Size of the virtual disk in gigabytes"
  type        = number
  default     = 40
}

variable "network_type" {
  description = "Network mode for the VM"
  type        = string
  default     = "bridged"
}

variable "iso_path" {
  description = "Path to the installation ISO"
  type        = string
  default     = ""
}

variable "guest_os" {
  description = "Guest operating system type"
  type        = string
  default     = "ubuntu64Guest"
}
