#!/bin/bash

IP=127.0.0.1
PORT=8080
PONTOS=0

rpm -q sshpass
[ $? -ne 0 ] && yum -y install sshpass

./remove_comentarios.sh /etc/yum.conf | sed "s/ //g" |  grep -i "proxy=http://$IP:$PORT" &> /dev/null

if [ $? -eq 0 ]; then
	./log.sh -certo "Proxy configurado no yum."
	PONTOS=2
else
	./log.sh -errado "Proxy não configurado no yum."
fi

./log.sh -bold "\n SOMA: $PONTOS Pts"
echo $PONTOS >> /tmp/pontos_squid

exit 0
