# terraform
Terraform 2 Master 3 worker VM buildout:

From laptop edit the cluster.tf and provider.tf files for your environment

Run terraform init; to start the process
run terraform plan; to confirm your enviornment variables are correct
run terraform apply -input=false -auto-approve; this will begin the process of spinning up your infrastructure in your ESXi cluster


Ansible host configuration:

From laptop run

```
for x in `seq 0 4`; do ssh-keygen -R 10.224.114.10$x; ./sshcopy.sh pureuser@10.224.114.10$x; done
```
( replace above IP addresses with your own)


edit the inventory.ini file to match your enviornment

```
ansible-playbook -i inventory.ini prereqs.yaml --user pureuser --extra-vars "ansible_sudo_pass=pureuser"
```


On 1st node (copy root ssh key):
```
sudo su -
```
```
ssh-keygen; for x in `seq 0 4`; do ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=accept-new 10.224.114.10$x; done'
```
```
git clone https://github.com/kubernetes-incubator/kubespray.git
```
```
cd kubespray
```
```
sudo pip3 install -r requirements.txt

cp -rfp inventory/sample inventory/mycluster

declare -a IPS=(chi-btm-pwx-n0,10.224.114.100 chi-btm-pwx-n1,10.224.114.101 chi-btm-pwx-n2,10.224.114.102 chi-btm-pwx-n3,10.224.114.103 chi-btm-pwx-n4,10.224.114.104)

CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

nano inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml #change k8s version to 1.18.10

sudo ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml
```
