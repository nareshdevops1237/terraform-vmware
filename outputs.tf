output "vm_name" {
  description = "The deployed VMware virtual machine name"
  value       = vmwareworkstation_virtual_machine.example.name
}

output "vm_id" {
  description = "The deployed VMware virtual machine ID"
  value       = vmwareworkstation_virtual_machine.example.id
}
