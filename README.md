# terraform
Terraform 1 Master 3 worker VM buildout:

From laptop edit the cluster.tf and provider.tf files for your environment

Run terraform init; to start the process
run terraform plan; to confirm your enviornment variables are correct
run terraform apply -input=false -auto-approve; this will begin the process of spinning up your infrastructure in your ESXi cluster


Ansible host configuration:

From laptop run

for x in `seq 0 3`; do ssh-keygen -R 10.224.114.0$x; ./sshcopy.sh pureuser@10.224.114.0$x; done
  ( replace above IP addresses uo with your own)


edit the inventory.ini file to match your enviornment

ansible-playbook -i inventory.ini prereqs.yaml --user pureuser --extra-vars "ansible_sudo_pass=pureuser"



On 1st node (copy root ssh key):

sudo su -

ssh-keygen; for x in `seq 0 3`; do ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=accept-new 10.224.114.0$x; done


git clone https://github.com/kubernetes-incubator/kubespray.git
cd kubespray
sudo pip3 install -r requirements.txt
cp -rfp inventory/sample inventory/mycluster
declare -a IPS=(chi-btm-pwx-n0,10.224.114.0 chi-btm-pwx-n1,10.224.114.1 chi-btm-pwx-n2,10.224.115.2 chi-btm-pwx-n3,10.224.114.3)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
vi inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml #change k8s version to 1.18.10

sudo ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml
