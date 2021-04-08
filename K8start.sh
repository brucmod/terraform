#ssh-keygen; for x in `seq 0 3`; do ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=accept-new 10.89.13.x{48 + x}; done

#git clone https://github.com/kubernetes-incubator/kubespray.git

#cd kubespray

#sudo pip3 install -r requirements.txt

#cp -rfp inventory/sample inventory/mycluster

#declare -a IPS=(cdw-btm-pwx-n0,10.89.13.48 cdw-btm-pwx-n1,10.89.13.49 cdw-btm-pwx-n2,10.89.13.50 cdw-btm-pwx-n3,10.89.13.51)

#CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

#nano inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml #change k8s version to 1.18.10

#sudo ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml


helm repo add pso-explorer 'https://raw.githubusercontent.com/PureStorage-OpenConnect/pso-explorer/master/'
helm repo update
helm search repo pso-explorer -l
kubectl create namespace psoexpl
helm install pso-explorer pso-explorer/pso-explorer --namespace psoexpl
kubectl get svc --namespace psoexpl -w pso-explorer
