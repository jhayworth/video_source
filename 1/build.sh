#!/bin/bash

generate_ansible_inventory () {
    if [ -f "playbooks/inventory" ]; then
        rm -f playbooks/inventory
    fi

    cp templates/ansible_inventory.template playbooks/inventory
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
	
        terraform apply | tee terraform.log
        echo "Sleeping for 20 seconds while the servers warm up"
        sleep 20s
        read -p "Terraform should be done. Continue?"
    
        cd playbooks
        ansible-playbook -vv -i inventory ping.yaml
        read -p "Ping test done. Continue?"
        ;;

    "destroy")
        terraform destroy
        ;;

    "clean")
        rm -f playbooks/inventory
        rm -f *.log
        ;;
    
esac
