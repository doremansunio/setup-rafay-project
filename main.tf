 # Create new Rafay Project
resource "rafay_project" "rafay_proj_new" {  
  metadata {
    name        = var.project_name
    description = "terraform project"
  }
  spec {
    default = false    
    cluster_resource_quota {
      cpu_requests = var.proj_cpu_requests
      memory_requests = var.proj_memory_requests
      cpu_limits = var.proj_cpu_limits
      memory_limits = var.proj_memory_limits
      config_maps = var.proj_config_maps
      persistent_volume_claims = var.proj_persistent_volume_claims
      services = var.proj_services
      pods = var.proj_pods
      replication_controllers = var.proj_replication_controllers
      services_load_balancers = var.proj_services_load_balancers
      services_node_ports = var.proj_services_node_ports
      storage_requests = var.proj_storage_requests
      gpu_requests = var.proj_gpu_requests
      gpu_limits = var.proj_gpu_limits
    }
    default_cluster_namespace_quota {
      cpu_requests = var.ns_cpu_requests
      memory_requests = var.ns_memory_requests
      cpu_limits = var.ns_cpu_limits
      memory_limits = var.ns_memory_limits
      config_maps = var.ns_config_maps
      persistent_volume_claims = var.ns_persistent_volume_claims
      services = var.ns_services
      pods = var.ns_pods
      replication_controllers = var.ns_replication_controllers
      services_load_balancers = var.ns_services_load_balancers
      services_node_ports = var.ns_services_node_ports
      storage_requests = var.ns_storage_requests
      gpu_requests = var.ns_gpu_requests
      gpu_limits = var.ns_gpu_limits
    } 
  }
}

# Create new Rafay workspace group
resource "rafay_group" "group-Workspace" {
  depends_on = [rafay_project.rafay_proj_new]
  name        = "WrkspAdmin-grp-${var.project_name}"
  description = "Workspace Admin Group for ${var.project_name}"  
}

# Creare new group assocication
resource "rafay_groupassociation" "group-association" {
  depends_on = [rafay_group.group-Workspace]
  group      = "WrkspAdmin-grp-${var.project_name}"
  project    = var.project_name
  roles = ["WORKSPACE_ADMIN","ENVIRONMENT_TEMPLATE_USER"]
  #add_users = ["${var.workspace_admins}"]
  add_users = var.workspace_admins
}

resource "rafay_cluster_sharing" "demo-terraform-specific" {  
  depends_on = [rafay_groupassociation.group-association]
  clustername = var.cluster_name
  project     = var.central_pool_name
  sharing {
    all = false
    dynamic "projects" {
      for_each = var.projects_to_share
      content {
        name = projects.value  
      }   
    } 
  }  
  # sharing {
  #   all = false
  #   projects {
  #     name = var.project_name
  #   }    
  # }
}

data "template_file" "tempnetfile" {    
  depends_on = [rafay_cluster_sharing.demo-terraform-specific]
  //depends_on = [rafay_groupassociation.group-association]
  template = file("${path.module}/net-policy-template.yaml")
  vars = {
      project_name = var.project_name
  }
}

resource "github_repository_file" "netfile" {
  depends_on = [data.template_file.tempnetfile]
  repository     = var.git_repo_name
  branch         = var.git_repo_branch
  file           = "netfiles/${var.project_name}-within-ws-rule.yaml"
  content        = data.template_file.tempnetfile.rendered
  commit_message = "${var.project_name}-within-ws-rule.yaml created"
  overwrite_on_create = true
}
