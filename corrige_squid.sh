#!/bin/bash


echo "0" > /tmp/pontos_squid

./log.sh -title "CNC"
./corrige_cnc.sh

TIME='1s'
sleep $TIME

if [ $? -eq 0 ]; then
	SQUID_CONF="/etc/squid/squid.conf"

	# Remover comentários do arquivo
	./remove_comentarios.sh $SQUID_CONF > /tmp/squid.conf
	SQUID_CONF="/tmp/squid.conf"

	# Corrigir parâmetros
	./log.sh -title "PARÂMETROS"  "ERRO"
	./corrige_params.sh $SQUID_CONF
	sleep $TIME

	# Corrigir Usuários
        ./log.sh -title "USUÁRIOS" "ACL" "HTTP_ACCESS"
        ./corrige_usuarios.sh $SQUID_CONF
	sleep $TIME

	 # Corrigir ACL's
        ./log.sh -title "ACL'S DO ALUNO"
        ./corrige_acl.sh $SQUID_CONF
	sleep $TIME

	 # Corrigir HTTP_ACCESS
        ./log.sh -title "HTTP_ACCESS DO ALUNO"
        ./corrige_http_access.sh $SQUID_CONF
	sleep $TIME
fi

./log.sh -title "CORREÇÃO DO SQUID FINALIZADA!"

TOTAL=0
while read PONTO; do
	TOTAL=$(($TOTAL + $PONTO))
done < /tmp/pontos_squid

./log.sh -bold "\n TOTAL: $TOTAL Pts\n"

