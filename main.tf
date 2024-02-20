 # Create new Rafay Project
resource "rafay_project" "rafay_proj_new" {  
  metadata {
    name        = var.project_name
    description = "terraform project"
  }
  spec {
    default = false    
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
  add_users = ["${var.workspace_admins}"]
}

 # Share the Rafay cluster
# resource "rafay_cluster_sharing" "demo-terraform-specific" {
#   depends_on = [rafay_groupassociation.group-association]
#   clustername = "${var.cluster_name}"
#   project     = "${var.central_pool_name}"
#   sharing {
#     all = false
#     projects {
#       name = "${var.project_name}"
#     }    
#   }
# }

resource "rafay_cluster_sharing" "demo-terraform-specific" {  
  clustername = "eks-cluster"
  project     = "central-pool"
  sharing {
    all = false
    projects {
      name = var.project_name
    }    
  }
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
