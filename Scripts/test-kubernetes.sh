#!/bin/bash
set -e

# Check if running as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Install required packages
echo "Updating system packages..."
yum update -y

echo "Installing required packages..."
yum install -y yum-utils device-mapper-persistent-data lvm2 curl wget git

# Install Docker
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Add Kubernetes repository and install kubelet, kubeadm, and kubectl
if ! command -v kubectl &> /dev/null; then
    echo "Installing Kubernetes components..."
    cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

    setenforce 0
    sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

    yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
    systemctl enable kubelet && systemctl start kubelet
fi

# Initialize Kubernetes master node
if [ ! -f /etc/kubernetes/admin.conf ]; then
    echo "Initializing Kubernetes master node..."
    kubeadm init --pod-network-cidr=10.244.0.0/16
fi

# Set up Kubernetes configuration for non-root user
if [ ! -f $HOME/.kube/config ]; then
    echo "Setting up Kubernetes configuration for non-root user..."
    mkdir -p $HOME/.kube
    sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
fi

# Install Flannel CNI plugin
if ! kubectl get pods -n kube-system | grep flannel &> /dev/null; then
    echo "Installing Flannel CNI plugin..."
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
fi

# Print join command for worker nodes
if command -v kubeadm &> /dev/null; then
    kubeadm token create --print-join-command > /tmp/join-command.txt
    echo "Join command saved to /tmp/join-command.txt"
fi

echo "Kubernetes installation completed successfully!"
