#!/bin/bash


echo "0" > /tmp/pontos_squid

HOST_PROXY=$1
HOST_SERV=$2
PASSWD_ROOT_SERV=$3

./log.sh -title "CNC"
./corrige_cnc.sh
CNC=$?

TIME='1s'
sleep $TIME

if [ $CNC -eq 0 ]; then
	SQUID_CONF="/etc/squid/squid.conf"

	# Obtém a porta usada nas configurações do aluno
	PROXY_PORT=$(./remove_comentarios.sh $SQUID_CONF | sed -n '/'http_port'/p' | awk '{print $2}')

	if [ -z $PROXY_PORT ]; then
        	PROXY_PORT=3128
	fi


	# Remover comentários do arquivo
	./remove_comentarios.sh $SQUID_CONF > /tmp/squid.conf
	SQUID_CONF="/tmp/squid.conf"

	# Corrigir parâmetros
	./log.sh -title "PARÂMETROS"  "ERRO/VALOR"
	./corrige_params.sh $SQUID_CONF
	sleep $TIME

	# Corrigir Usuários
        ./log.sh -title "USUÁRIOS" "ACL" "TESTE CURL"
        ./corrige_usuarios.sh $SQUID_CONF "$HOST_PROXY" "$PROXY_PORT"
	sleep $TIME

	 # Corrigir ACL's
        ./log.sh -title "ACL'S DO ALUNO"
        ./corrige_acl.sh $SQUID_CONF
	sleep $TIME

	 # Corrigir HTTP_ACCESS
        ./log.sh -title "HTTP_ACCESS DO ALUNO"
        ./corrige_http_access.sh $SQUID_CONF
	sleep $TIME

	./log.sh -title "YUM PROXY"
        ./corrige_yum.sh $SQUID_CONF "$HOST_PROXY" "$PROXY_PORT" "$HOST_SERV" "$PASSWD_ROOT_SERV"
        sleep $TIME
fi

./log.sh -title "CORREÇÃO DO SQUID FINALIZADA!"

TOTAL=0
while read PONTO; do
	TOTAL=$(($TOTAL + $PONTO))
done < /tmp/pontos_squid

./log.sh -bold "\n TOTAL: $TOTAL Pts\n"

