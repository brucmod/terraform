for x in `seq 0 3`; do ssh-keygen -R 10.89.13.48+$x; ./sshcopy.sh pureuser@10.89.13.48+$x; done
ansible-playbook -i inventory.ini prereqs.yaml --user pureuser --extra-vars "ansible_sudo_pass=pureuser"
