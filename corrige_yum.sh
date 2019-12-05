#!/bin/bash

SQUID_CONF=$1
HOST_PROXY=$2
PROXY_PORT=$3
HOST_SERV=$4
PASSWD_ROOT_SERV=$5
SSH_PORT=22

# Obtém o ip interno do servidor proxy
HOST_PROXY_INTERNO=$(./obtem_config.sh GLOBAL_CONFIG -p host_proxy_interno | awk '{print $2}')

#rpm -q sshpass
#[ $? -ne 0 ] && yum -y install sshpass

# Obtém os pontos da questao
PONTOS=$(./obtem_config.sh YUM_PROXY -p pontos | sed -e "s/[^0-9\.]//g")

# Verifica se a máquina está disponível
ping -c5 $HOST_SERV &> /dev/null
if [ $? -eq 0 ]; then 
	
	echo "" > /tmp/yum_$HOST_SERV.conf

	# Copia o arquivo do host que deve ser verificado o proxy do yum
	sshpass -p $PASSWD_ROOT_SERV scp \
        	-P $SSH_PORT \
	        -o "StrictHostKeyChecking no" \
		-o "ConnectTimeout=5" \
        	root@$HOST_SERV:/etc/yum.conf \
		/tmp/yum_$HOST_SERV.conf &> /dev/null
	
	if [ $? -eq 0 ]; then 
		# Verifica o proxy
		./remove_comentarios.sh /tmp/yum_$HOST_SERV.conf | sed "s/ //g" > /tmp/proxy_configurado
		cat /tmp/proxy_configurado | grep -i "proxy=http://$HOST_PROXY:$PROXY_PORT" &> /dev/null
		CORRETO=$?

		# Verifica com o ip interno do proxy
		if [ $CORRETO -ne 0 ]; then
			#echo $HOST_PROXY_INTERNO
			cat /tmp/proxy_configurado | grep -i "proxy=http://$HOST_PROXY_INTERNO:$PROXY_PORT" &> /dev/null
			CORRETO=$?
		fi

		if [ $CORRETO -eq 0 ]; then
			./log.sh -certo "Proxy configurado no yum do servidor $HOST_SERV."
		else
			./log.sh -errado "Proxy não configurado no yum do servidor $HOST_SERV."
			PONTOS=0
		fi
	else
		PONTOS=0
		./log.sh -errado "Não foi possível acessar $HOST_PROXY"
	fi

	./log.sh -bold "\n SOMA: $PONTOS Pts"
	echo $PONTOS >> /tmp/pontos_squid

	exit 0

else
	./log.sh -errado "Servidor $HOST_SERV não está disponível."
	./log.sh -bold "\n SOMA: 0 Pts"
	echo $PONTOS >> /tmp/pontos_squid

	exit 1
fi

