# EXAMPLE OF EKS RUNNING DOCKER IMAGES IN ECR
## REQUIREMENTS
- [AWS CLI installed](https://aws.amazon.com/es/cli/)
- [Docker installed](https://docs.docker.com/desktop/install/ubuntu/)
- [Kubectl installed](https://kubernetes.io/es/docs/tasks/tools/included/install-kubectl-linux/)
## Create an ECR registry & push your image to ECR
[Tutorial](https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html#cli-create-repository)
## Build a Dockerfile
### Create a Dockerfile:
```bash
cat << EOF > Dockerfile
FROM httpd
COPY apt update 
RUN apt install apache2 --yes
RUN apt install apache2-utils --yes
RUN apt clean 
EXPOSE 80
CMD [“apache2ctl”, “-D”, “FOREGROUND”]
EOF
```
### Build your image
```bash
docker build -t my_apache_image .
```
### TEST LOCALLY
```bash
docker run -d -p 80:80 my_apache_image 
```
### tag your app image
```bash
docker tag your-app-image-name:latest 123456789101112.dkr.ecr.us-east-1.amazonaws.com/your-app-image-name 
```
### Loggin to ECR 
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789101112.dkr.ecr.us-east-1.amazonaws.com/your-app-image-name /
```
### push your image to ECR
```bash
docker push 123456789101112.dkr.ecr.us-east-1.amazonaws.com/your-app-image-name
```
## Terraform
### To create resources run locally:
```bash
git pull
terraform init
terraform plan
terraform apply
```
### Above commands take several minutes to complete and require confirmations
## Configure kubectl
Once new resources are created you will need to modify your ~/.kube/config in certificate-authority-data and server fields according to your cluster data
### to show running kubernetes pods
```bash
kubectl get pods
```
### pull a test image from hub.docker.com
```bash
docker pull httpd:latest
```
### run a container from local image in EKS
```bash 
kubectl run httpd --image=httpd:latest
```
### run a pod from ECR image 
```bash
kubectl run your-app-pod-name --image=123456789101112.dkr.ecr.us-east-1.amazonaws.com/your-app-image-name
```
### Create a service to expose pod
```bash
kubectl expose pod your-app-pod-name --port=80 --name=your-svc-name --type=NodePort
```
### Describe service and take "Endpoints"
```bash
kubectl describe svc your-svc-name
```

# Endpoint to access the web