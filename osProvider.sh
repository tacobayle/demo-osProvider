#!/bin/bash
echo "Copying the github repos"
ansible-playbook git.yml
echo "#####################################"
echo "Adding route to the ansible host"
sudo ip route add 200.1.1.11/32 via 192.168.139.135 || true
echo "#####################################"
echo "Apply the configuration"
cd devstack
ansible-playbook -i hostsLocalKvm main.yml
read -n 1 -s -r -p "Press any key to continue the Avi Config"
cd ../aviKvm
ansible-playbook -i hostsLocalKvm generateHosts.yml
ansible-playbook -i hostsLocalKvm generateCreds.yml
cd ../aviBootstrap
ansible-playbook -i hostsLocalKvm main.yml
cd ../aviOs
ansible-playbook main.yml
cd ..
rm -fr devstack aviKvm aviBootstrap aviOs
