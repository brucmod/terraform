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


SSH as root on 1st node 
```
git clone https://github.com/brucmod/tk8
```

```
cd tk8
```
```
chmod +x K8start.sh
```
```
./K8start
```

