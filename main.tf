 # Create new Rafay Project
resource "rafay_project" "rafay_proj_new" {  
  metadata {
    name        = var.project_name
    description = "terraform project"
  }
  spec {
    default = false    
    cluster_resource_quota {
      cpu_requests = var.cpu_requests
      memory_requests = var.memory_requests
      cpu_limits = var.cpu_limits
      memory_limits = var.memory_limits              
      pods = var.pods
      services = var.services    
      services_load_balancers = var.services_load_balancers
      services_node_ports = var.services_node_ports
      persistent_volume_claims = var.persistent_volume_claims
      storage_requests = var.storage_requests
    }
    # cluster_resource_quota {
    #   cpu_requests = "4000m"
    #   memory_requests = "4096Mi"
    #   cpu_limits = "8000m"
    #   memory_limits = "8192Mi"
    #   config_maps = "10"
    #   persistent_volume_claims = "5"
    #   services = "20"    
    #   pods = "200"
    #   replication_controllers = "10"
    #   services_load_balancers = "10"
    #   services_node_ports = "10"
    #   storage_requests = "100Gi"
    # }
    # default_cluster_namespace_quota {
    #   cpu_requests = "1000m"
    #   memory_requests = "1024Mi"
    #   cpu_limits = "2000m"
    #   memory_limits = "2048Mi"
    #   config_maps = "5"
    #   persistent_volume_claims = "2"
    #   services = "10"
    #   pods = "20"
    #   replication_controllers = "4"
    #   services_load_balancers = "4"
    #   services_node_ports = "4"
    #   storage_requests = "10Gi"
    # } 
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

data "template_file" "temp-within-ns-netfile" {    
  depends_on = [rafay_cluster_sharing.demo-terraform-specific]
  //depends_on = [rafay_groupassociation.group-association]
  template = file("${path.module}/net-policy-template.yaml")
  vars = {
      project_name = var.project_name
  }
}

resource "github_repository_file" "within-ns-netfile" {
  depends_on = [data.template_file.temp-within-ns-netfile]
  repository     = var.git_repo_name
  branch         = var.git_repo_branch
  file           = "netfiles/${var.project_name}-within-ws-rule.yaml"
  content        = data.template_file.temp-within-ns-netfile.rendered
  commit_message = "${var.project_name}-within-ws-rule.yaml created"
  overwrite_on_create = true
}

data "template_file" "temp-denyall-ns-netfile" {    
  depends_on = [github_repository_file.within-ns-netfile]
  //depends_on = [rafay_groupassociation.group-association]
  template = file("${path.module}/deny-all-ns.yaml")
}

resource "github_repository_file" "denyall-ns-netfile" {
  depends_on = [data.template_file.temp-denyall-ns-netfile]
  repository     = var.git_repo_name
  branch         = var.git_repo_branch
  file           = "netfiles/${var.project_name}-deny-all-ns-rule.yaml"
  content        = data.template_file.temp-denyall-ns-netfile.rendered
  commit_message = "${var.project_name}-deny-all-ns-rule.yaml created"
  overwrite_on_create = true
}

