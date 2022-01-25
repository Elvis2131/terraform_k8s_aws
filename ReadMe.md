I used the modules approach to separate the various parts and easy refactoring.

* VPC: Created a vpc with three subnets. 2 out of the 3 subnets are private, so I had to create a NAT gateway for the worker nodes to install dependencies and other packages by attaching it to its route table. The public subnet had an internet gateway attached to its route table.

* IAM: Created an IAM role for both the EKS cluster and the node group to assume by attaching the needed policy arns.
* K8s: Provisioned the cluster with variables coming from both the vpc and iam modules, also allowed the endpoint access to both public and private just so that the worker node can join the cluster using the private endpoint to cut down the overhead.  Created a node group with the needed scaling policies, subnet, and cluster-info.

To get variables from other modules, I had to output the needed info and tag it to the module declaration in the main.tf file.