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

# Copia o arquivo do host que deve ser verificado o proxy do yum
sshpass -p $PASSWD_ROOT_SERV scp \
        -P $SSH_PORT \
        -o "StrictHostKeyChecking no" \
        root@$HOST_SERV:/etc/yum.conf \
	/tmp/yum_$HOST_SERV.conf

# Verifica o proxy
./remove_comentarios.sh /tmp/yum_$HOST_SERV.conf | sed "s/ //g" > /tmp/proxy_configurado
cat /tmp/proxy_configurado | grep -i "proxy=http://$HOST_PROXY:$PROXY_PORT" &> /dev/null
CORRETO=$?

# Verifica com o ip interno do proxy
if [ $CORRETO -ne 0 ]; then
	echo $HOST_PROXY_INTERNO
	cat /tmp/proxy_configurado | grep -i "proxy=http://$HOST_PROXY_INTERNO:$PROXY_PORT" &> /dev/null
	CORRETO=$?
fi

if [ $CORRETO -eq 0 ]; then
	./log.sh -certo "Proxy configurado no yum."
else
	./log.sh -errado "Proxy não configurado no yum."
	PONTOS=0
fi

./log.sh -bold "\n SOMA: $PONTOS Pts"
echo $PONTOS >> /tmp/pontos_squid

exit 0
