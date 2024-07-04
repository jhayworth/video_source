#!/bin/bash

echo "Directory: `pwd`"

if [ "$1" == "test_server" ]; then
    echo "Replacing primary server IP in ansible inventory with $2"
    sed -i "s/{:test_server_ip:}/$2/g" playbook/inventory
fi
