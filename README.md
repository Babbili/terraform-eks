i# Creating AWS EKS cluster with Terraform 

This repo show cases automating infrastructure building and provisioning on AWS using Terraform as Infrastructure as Code (IaC) tool to create an EKS cluster ,Elastic Kubernetes Service, with auto-scaling self-managed nodes group and its underlaying networking using [Terraform AWS Modules](https://registry.terraform.io/modules/terraform-aws-modules/) 

## get started

run terraform init to initialize the backend and modules and the provider plugins
and will create `.terraform` directory and `.terraform.lock.hcl` file

```bash

terraform init

# output
Initializing the backend...
Initializing modules...
...
Initializing provider plugins...
...
Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

validate the terraform configuration files
```bash
terraform validate
Success! The configuration is valid.
```

Run terraform plan to preview the changes that Terraform proposes to make to their infrastructure before applying them

```bash
terraform plan
```

in our case it will create 

    - VPC, CIDR `10.200.0.0/16` with three private and three public across the three Availability Zones in us‑east‑1, Internet Gateway, NAT Gateway and Route Table.
    - EKS Cluster, name _debian-eks_, Kubernetes version 1.33, private API endpoint, encryption enabled, EKS Add‑ons – CoreDNS, kube‑proxy, and vpc‑cni.
    - Node Group (Self‑Managed), instance type _t2.small_ with Auto Scaling Group, desired 1, min 1, max 3, spread across AZs
    - Security Groups such as a cluster SG, VPC ACL/SG and a Node Group SG and their Security Group Rules.
    - IAM Role for the EKS Cluster with the _AmazonEKSClusterPolicy_ attached, IAM Role for the Self‑Managed Node Group plus the standard worker‑node policies and IAM OpenID Connect Provider for IRSA plus cluster encryption (KMS).
    - CloudWatch Log Group for the EKS cluster


```bash
terraform apply
```
This will create the infrastructure and a **`terraform.tfstate`** file which stroes the state of our infrastructure and serves as the persistent record of the infrastructure managed by Terraform.

In my setup the `terraform.tfstate` file is stored in an S3 bucket. Storing the state file remotely enables multiple engineers to collaborate safely on provisioning the infrastructure, and it prevents race conditions by ensuring everyone works from the same up‑to‑date state file, as shown in `be-state.tf` file.


## deploy an app

connect to the cluster
```bash
aws eks update-kubeconfig --name debian-eks --region us-east-1

# this will add the `kubeconfig` file to $HOME/.kube/config and we can start using kubectl
```
We can check the cluster in the console

<img src="./img/2025-11-16 17-42-23.png" />

i'm deploying a simple Python flask app
```bash
kubectl apply -f k8s-manifests/pyapp.yaml

#output
namespace/apps unchanged
deployment.apps/pyapp created
service/pyapp created
serviceaccount/pyapp created
secret/pyapp-svca-token created

```
check the resources deployed
```bash
kubectl -n apps get all

#output
NAME                        READY   STATUS    RESTARTS   AGE
pod/pyapp-c797c4475-4xg4h   1/1     Running   0          87s
pod/pyapp-c797c4475-69nl9   1/1     Running   0          87s
pod/pyapp-c797c4475-75ds2   1/1     Running   0          87s

NAME            TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
service/pyapp   ClusterIP   10.96.126.2   <none>        80/TCP    87s

NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/pyapp   3/3     3            3           87s

NAME                              DESIRED   CURRENT   READY   AGE
replicaset.apps/pyapp-c797c4475   3         3         3       87s

```

## clean up

```bash
terraform destroy
```



