# Learn Helm commands


## Install helm

Script method

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

Apt package manager

```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

## Using Helm

### 1. Add repos

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```
### 2. Update repos

```
helm repo update
```

### 3. Search for a chart in repos

```bash
helm search repo <name-of-chart>
```

### 4. To download a chart

```
helm pull <repo>/<chart> --untar
```


### 5. Install/Deploy a chart

```
helm install <release-name> <chart> --dry-run
```
or
```
helm install <release-name> <repo>/<chart> 
```