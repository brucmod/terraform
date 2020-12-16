#ssh-keygen; for x in 'seq 0 4'; do ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=accept-new 10.224.114.10$x; done

#git clone https://github.com/kubernetes-incubator/kubespray.git

#cd kubespray

#sudo pip3 install -r requirements.txt

#cp -rfp inventory/sample inventory/mycluster

#declare -a IPS=(chi-btm-pwx-n0,10.224.114.100 chi-btm-pwx-n1,10.224.114.101 chi-btm-pwx-n2,10.224.114.102 chi-btm-pwx-n3,10.224.114.103 chi-btm-pwx-n4,10.224.114.104)

#CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

#nano inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml #change k8s version to 1.18.10

#sudo ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml



kubectl create namespace pure-pso

kubectl create -f  https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
kubectl create -f  https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
kubectl create -f  https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
kubectl apply -n default -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
kubectl apply -n default -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml

helm repo add pure --force-update https://purestorage.github.io/pso-csi
helm repo update
helm install pure-pso pure/pure-pso --namespace pure-pso -f values.yaml

helm repo add pso-explorer 'https://raw.githubusercontent.com/PureStorage-OpenConnect/pso-explorer/master/'
helm repo update
helm search repo pso-explorer -l
kubectl create namespace psoexpl
helm install pso-explorer pso-explorer/pso-explorer --namespace psoexpl
kubectl get svc --namespace psoexpl -w pso-explorer
