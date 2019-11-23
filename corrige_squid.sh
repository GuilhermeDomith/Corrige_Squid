#!/bin/bash


./log.sh -title "CRITÉRIO PARA NÃO CORREÇÃO"
./corrige_cnc.sh

if [ $? -eq 0 ]; then
	SQUID_CONF="/etc/squid/squid.conf"

	# Remover comentários do arquivo
	./remove_comentarios.sh $SQUID_CONF > /tmp/squid.conf
	SQUID_CONF="/tmp/squid.conf"

	# Corrigir parâmetros
	./log.sh -title "PARÂMETROS"  "ERRO"
	./corrige_params.sh $SQUID_CONF

	# Corrigir Usuários
        ./log.sh -title "USUÁRIOS" "ACL" "HTTP_ACCESS"
        ./corrige_usuarios.sh $SQUID_CONF

	 # Corrigir ACL's
        ./log.sh -title "ACL'S DO ALUNO"
        ./corrige_acl.sh $SQUID_CONF

	 # Corrigir HTTP_ACCESS
        ./log.sh -title "HTTP_ACCESS DO ALUNO"
        ./corrige_http_access.sh $SQUID_CONF
fi

./log.sh -t "CORREÇÃO DO SQUID FINALIZADA!"

