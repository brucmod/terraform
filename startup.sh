for x in `seq 0 4`; do ssh-keygen -R 10.224.114.10$x; ./sshcopy.sh pureuser@10.224.114.10$x; done
ansible-playbook -i inventory.ini prereqs.yaml --user pureuser --extra-vars "ansible_sudo_pass=pureuser"
