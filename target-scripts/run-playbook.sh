#!/bin/bash

cd $(dirname $0)
CURRENT_DIR=$(pwd)

source ./config.sh
source ./venv.sh

./extract-kubespray.sh

cp -r ./playbook kubespray-${KUBESPRAY_VERSION}/offline-playbook
cd kubespray-${KUBESPRAY_VERSION}
pip install -U pip
pip install -r requirements.txt
ansible-playbook -i ../cluster/hosts.yaml -u devops -k -K -b --become --become-user=root offline-playbook/offline-repo.yml
ansible-playbook -i ../cluster/hosts.yaml -u devops -k -K -b --become --become-user=root cluster.yml
