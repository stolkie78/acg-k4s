#1 - Once we have logged in, we need to elevate privileges using sudo:

sudo su  
#2 - Disable SELinux:

setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
#3 - Enable the br_netfilter module for cluster communication:

modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
#4 - Ensure that the Docker dependencies are satisfied:

yum install -y yum-utils device-mapper-persistent-data lvm2
#5 - Add the Docker repo and install Docker:

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
#6 - Set the cgroup driver for Docker to systemd, reload systemd, then enable and start Docker:

sed -i '/^ExecStart/ s/$/ --exec-opt native.cgroupdriver=systemd/' /usr/lib/systemd/system/docker.service
systemctl daemon-reload
systemctl enable docker --now
#7 - Add the Kubernetes repo:

cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
  https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
#8 - Install Kubernetes v1.14.0:

yum install -y kubelet-1.14.0-0 kubeadm-1.14.0-0 kubectl-1.14.0-0 kubernetes-cni-0.7.5
#9 - Enable the kubelet service. The kubelet service will fail to start until the cluster is initialized, this is expected:

systemctl enable kubelet