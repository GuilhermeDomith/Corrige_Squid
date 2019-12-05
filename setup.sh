#!/bin/bash

HOST_PROXY=$(./obtem_config.sh GLOBAL_CONFIG -p host_proxy_externo | awk '{print $2}' )
HOST_PROXY=$( ([ -z $1 ] && echo $HOST_PROXY) || echo $1)

HOST_SERV=$(./obtem_config.sh YUM_PROXY -p host | awk '{print $2}' )
HOST_SERV=$( ([ -z $2 ] && echo $HOST_SERV) || echo $2)

./log.sh -i "IP VM PROXY: $HOST_PROXY"
./log.sh -i "IP VM SERVIDOR: $HOST_SERV"

#HOST_PROXY=$1
#SSH_PORT=22
#HOST_SERV=$2

if [ -z $HOST_PROXY ] || [ -z $HOST_SERV ]; then
	echo ""
	./log.sh -i "'IP VM PROXY' ou 'IP VM SERVIDOR' não informado."
	./log.sh -i "Informe ambos os ip's no arquivo 'corrige_squid.conf'"
	./log.sh -i "ou passe os mesmos por parâmetro.\n"
	./log.sh -i "SINTAXE: ./setup.sh [IP VM PROXY] [IP VM SERVIDOR]"
	./log.sh -i "    EX.: ./setup.sh 192.168.0.37 10.3.2.1\n"
	 exit 1
fi

PASSWD_ROOT_PROXY=$(./obtem_config.sh GLOBAL_CONFIG -p root_password | awk '{print $2}')
PASSWD_ROOT_SERV=$(./obtem_config.sh YUM_PROXY -p root_password | awk '{print $2}')

# Obtém a porta do SSH que deve ser configurada ou a porta padrão
SSH_PORT=$(./obtem_config.sh GLOBAL_CONFIG -p ssh_port | awk '{print $2}' )
SSH_PORT=$( ([ -z $SSH_PORT ] && echo 22 ) || echo $SSH_PORT)

PATH_SCRIPTS=$(pwd)
PATH_DIR_REMOTO=$(echo "~/$(pwd | awk -F"/" '{print $NF}')")

./log.sh -i "Copiando arquivos para $HOST_PROXY..."

# Copia os scripts para o sevidor proxy
sshpass -p $PASSWD_ROOT_PROXY scp \
	-P $SSH_PORT \
	-o "StrictHostKeyChecking no" \
	-r $PATH_SCRIPTS \
	root@$HOST_PROXY:~/

# Realiza acesso remoto e executa o script para iniciar a correção
sshpass -p $PASSWD_ROOT_PROXY ssh \
	-p $SSH_PORT \
	-o "StrictHostKeyChecking no" \
	root@$HOST_PROXY \
	-t "cd $PATH_DIR_REMOTO; ./corrige_squid.sh $HOST_PROXY $HOST_SERV $PASSWD_ROOT_SERV; /bin/bash"

