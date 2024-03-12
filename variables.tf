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

variable "within_ws_ntwrk_policy_name" {
  type = string
}

variable "denyall_ns_ntwrk_policy_name" {
  type = string
}

variable "within_ws_ntwrk_policy_rule_name" {
  type = string
}

variable "denyall_ns_ntwrk_rule_name" {
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

variable "cpu_requests" {
  type = string  
}

variable "memory_requests" {
  type = string  
}

variable "cpu_limits" {
  type = string  
}

variable "memory_limits" {
  type = string  
}

variable "pods" {
  type = string  
}

variable "services" {
  type = string  
}

variable "services_load_balancers" {
  type = string  
}

variable "services_node_ports" {
  type = string  
}

variable "persistent_volume_claims" {
  type = string  
}

variable "storage_requests" {
  type = string  
}