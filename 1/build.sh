#!/bin/bash

generate_ansible_inventory () {
    if [ -f "playbook/inventory" ]; then
        rm -f playbook/inventory
    fi

    cp templates/ansible_inventory.template playbook/inventory
}

# Now we can run terraform
case $1 in
    "init")
        terraform init
        ;;

    "apply")
        export ANSIBLE_HOST_KEY_CHECKING=false
    
        generate_ansible_inventory
	read -p "Templates should be copied over. Continue?"
	
        terraform apply | tee terraform_run.log
        echo "Sleeping for 20 seconds while the servers warm up"
        sleep 20s
        read -p "Terraform should be done. Continue?"
    
        cd playbook
        ansible-playbook -vv -i inventory k8s-ping.yaml
        read -p "Ping test done. Continue?"
        ;;

    "destroy")
        terraform destroy
        ;;

    "clean")
        rm -f playbook/inventory
        rm -f *.log
        ;;
    
esac
