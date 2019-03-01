#!/bin/bash
echo "Copying the github repos"
ansible-playbook git.yml
echo "#####################################"
echo "Copying the Ansible hostfile"
cp hostsLocal devstack/hosts
cp hostsLocal devstack/aviKvm
echo "#####################################"
echo "Copying the config files"
cp params_devstack.yml devstack/vars/params.yml
cp params_aviKvm.yml aviKvm/vars/params.yml
cp params_aviBootstrap.yml aviBootstrap/vars/params.yml
cp params_aviOs.yml aviOs/vars/params.yml
echo "#####################################"
echo "Adding route to the ansible host"
sudo ip route add 200.1.1.11/32 via 192.168.139.135 || true
echo "#####################################"
echo "Apply the configuration"
cd devstack
ansible-playbook -i hosts main.yml
cd ../aviKvm
ansible-playbook -i hostsLocal generateHosts.yml
ansible-playbook -i hostsLocal generateCreds.yml
cd ../aviBootstrap
ansible-playbook -i hostslocalKvm main.yml
cd ../aviOs
ansible-playbook main.yml
cd ..
rm -fr devstack aviKvm aviBootstrap aviOs
