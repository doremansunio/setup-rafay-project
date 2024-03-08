variable "central_pool_name" {
  type = string  
}

variable "project_name" {
  type = string  
} 

variable "cluster_name" {
  type = string
}

variable "workspace_admins" {
  type    = list  
}

variable "projects_to_share" {
  type    = list  
}

variable "network_policy_name" {
  type = string
}

variable "network_policy_rule_name" {
  type = string
}

variable "network_policy_rule_version" {
  type = string  
}

variable "git_repo_name" {
  type = string  
}

variable "git_repo_branch" {
  type = string  
}

variable "proj_cpu_requests" {
  type = string  
}

variable "proj_memory_requests" {
  type = string  
}

variable "proj_cpu_limits" {
  type = string  
}

variable "proj_memory_limits" {
  type = string  
}

variable "proj_config_maps" {
  type = string  
}

variable "proj_persistent_volume_claims" {
  type = string  
}

variable "proj_services" {
  type = string  
}

variable "proj_pods" {
  type = string  
}

variable "proj_replication_controllers" {
  type = string  
}

variable "proj_services_load_balancers" {
  type = string  
}

variable "proj_services_node_ports" {
  type = string  
}

variable "proj_storage_requests" {
  type = string  
}

variable "proj_gpu_requests" {
  type = string  
}

variable "proj_gpu_limits" {
  type = string  
}

variable "ns_cpu_requests" {
  type = string  
}

variable "ns_memory_requests" {
  type = string  
}

variable "ns_cpu_limits" {
  type = string  
}

variable "ns_memory_limits" {
  type = string  
}

variable "ns_config_maps" {
  type = string  
}

variable "ns_persistent_volume_claims" {
  type = string  
}

variable "ns_services" {
  type = string  
}

variable "ns_pods" {
  type = string  
}

variable "ns_replication_controllers" {
  type = string  
}

variable "ns_services_load_balancers" {
  type = string  
}

variable "ns_services_node_ports" {
  type = string  
}

variable "ns_storage_requests" {
  type = string  
}

variable "ns_gpu_requests" {
  type = string  
}

variable "ns_gpu_limits" {
  type = string  
}
