ssh-keygen; for x in 'seq 0 4'; do ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=accept-new 10.224.114.10$x; done

git clone https://github.com/kubernetes-incubator/kubespray.git

cd kubespray

sudo pip3 install -r requirements.txt

cp -rfp inventory/sample inventory/mycluster

declare -a IPS=(chi-btm-pwx-n0,10.224.114.100 chi-btm-pwx-n1,10.224.114.101 chi-btm-pwx-n2,10.224.114.102 chi-btm-pwx-n3,10.224.114.103 chi-btm-pwx-n4,10.224.114.104)

CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

nano inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml #change k8s version to 1.18.10

sudo ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml
