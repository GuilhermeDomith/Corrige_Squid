#!/bin/bash

[ -z $1 ] && ./log.sh -i "HOST NÂO INFORMADO" && ./log.sh -i "EXEMPLO: ./setup.sh 192.168.0.37" && exit 1

HOST=$1
PATH_DIR=$(pwd)
PATH_DIR_REMOTO=$(echo "~/$(pwd |awk -F"/" '{print $NF}')")

sshpass -p admin scp -o "StrictHostKeyChecking no" -r $PATH_DIR root@$HOST:~/
sshpass -p admin ssh -o "StrictHostKeyChecking no" root@$HOST -t "cd $PATH_DIR_REMOTO; /bin/bash corrige_squid.sh; /bin/bash"

