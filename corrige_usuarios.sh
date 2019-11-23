#!/bin/bash

SQUID_CONF=$1

# Obtém as configurações do gabarito
./obtem_config.sh USUARIOS > /tmp/corrige_usuarios

# Obtém apenas ACL's e HTTP_ACCESS do aluno
grep "acl" $SQUID_CONF > /tmp/squid_acls
grep "http_access" $SQUID_CONF > /tmp/squid_http_access

#./log.sh -table-title "Usuário" "CRIADA ACL" "USADO EM HTTP_ACCESS"

while read USUARIO; do
	ACL_USUARIO=$(cat /tmp/squid_acls | sed -n "$(echo -e "/acl .* proxy_auth "$USUARIO"/p")")
	ACL_USUARIO=$(echo $ACL_USUARIO | awk '{print $2}')

	if [ -z $ACL_USUARIO ]; then
		./log.sh -errado "$(printf '%-48s %-20s %-10s\n' $USUARIO "" "")"
	else
		grep $ACL_USUARIO /tmp/squid_http_access &> /dev/null
		HTTP_ACCESS_USUARIO=$?


		if [ $HTTP_ACCESS_USUARIO -eq 0 ]; then
			./log.sh -certo "$(printf '%-48s %-20s %-10s\n' $USUARIO "[ $ACL_USUARIO ]" "[ CRIADO ]")"
		else
			./log.sh -errado "$(printf '%-48s %-20s %-10s\n' $USUARIO "[ $ACL_USUARIO ]" "")"
		fi
	fi
	
done < /tmp/corrige_usuarios

