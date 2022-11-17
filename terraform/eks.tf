data "aws_eks_cluster" "default" {
  name = module.eks_internal.eks_cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks_internal.eks_cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

module "eks_test" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.7.0"

  # EKS CLUSTER
  cluster_version           = "1.21"
  cluster_name              = "eks-test"
  vpc_id                    = "vpc-1"                                      
  private_subnet_ids        = ["subnet-1", "subnet-2", "subnet-3"]     
  tags                      = merge({
    "tag1"       =	"foo"  
    "tag2"       =	"bar"
    })
  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
    mg_m5 = {
      node_group_name = "managed-ondemand"
      instance_types  = ["t3.small"]
      subnet_ids      = ["subnet-1", "subnet-2", "subnet-3"]
      min_size        = 5
      max_size        = 7
      desired_size    = 5
    }
  }
}

module "eks_internal_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.7.0"

  eks_cluster_id = module.eks_internal.eks_cluster_id

  # EKS Addons
  enable_amazon_eks_vpc_cni            = true
  enable_amazon_eks_coredns            = true
  enable_amazon_eks_kube_proxy         = true
  enable_amazon_eks_aws_ebs_csi_driver = true

  #K8s Add-ons
  enable_aws_for_fluentbit            = true
  enable_aws_load_balancer_controller = true
  enable_cluster_autoscaler           = true
  enable_metrics_server               = true
  enable_prometheus                   = true
}