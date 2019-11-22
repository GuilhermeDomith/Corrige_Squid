#!/bin/bash


./log.sh -title "CRITÉRIO PARA NÃO CORREÇÃO"
./corrige_cnc.sh

if [ $? -eq 0 ]; then
	SQUID_CONF="/etc/squid/squid.conf"

	# Remover comentários do arquivo
	./remove_comentarios.sh $SQUID_CONF > /tmp/squid.conf
	SQUID_CONF="/tmp/squid.conf"

	# Corrigir parâmetros
	./log.sh -title "PARÂMETROS UNICOS"
	./corrige_params.sh $SQUID_CONF

	 # Corrigir ACL's
        ./log.sh -title "ACL'S"
        ./corrige_acl.sh $SQUID_CONF

	 # Corrigir HTTP_ACCESS
        ./log.sh -title "HTTP ACCESS"
        ./corrige_http_access.sh $SQUID_CONF
fi

./log.sh -t "CORREÇÃO DO SQUID FINALIZADA!"

