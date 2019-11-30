#!/bin/bash

SQUID_CONF=$1

# Obtém as configurações do gabarito
./obtem_config.sh USUARIOS > /tmp/corrige_usuarios

# Obtém apenas ACL's e HTTP_ACCESS do aluno
grep "acl" $SQUID_CONF > /tmp/squid_acls
grep "http_access" $SQUID_CONF > /tmp/squid_http_access

#./log.sh -table-title "Usuário" "CRIADA ACL" "USADO EM HTTP_ACCESS"

PONTOS=0
while read CONF_USUARIO; do

	PONTO=$(echo $CONF_USUARIO | awk -F")" '{print $1}' | sed -e "s/[^0-9\.]//g")
        USUARIO=$(echo $CONF_USUARIO | awk -F")" '{print $2}'| awk '{print $1}')
	
#echo $PONTO '|'
#echo $USUARIO '|'
	ACL_SEARCH=$(echo -e "acl .* proxy_auth $USUARIO")
#echo "$ACL_SEARCH" '|'

	ACL_USUARIO=$(cat /tmp/squid_acls | sed -n "/$ACL_SEARCH/p")
#echo $ACL_USUARIO '|'
	ACL_USUARIO=$(echo $ACL_USUARIO | awk '{print $2}')

	if [ -z $ACL_USUARIO ]; then
		./log.sh -errado "$(printf '%-50s %-20s %-10s\n' "$CONF_USUARIO" "" "")"
		PONTO=0
	else
		grep $ACL_USUARIO /tmp/squid_http_access &> /dev/null
		HTTP_ACCESS_USUARIO=$?


		if [ $HTTP_ACCESS_USUARIO -eq 0 ]; then
			./log.sh -certo "$(printf '%-50s %-20s %-10s\n' "$CONF_USUARIO" "[ $ACL_USUARIO ]" "[ CRIADO ]")"
		else
			./log.sh -errado "$(printf '%-50s %-20s %-10s\n' "$CONF_USUARIO" "[ $ACL_USUARIO ]" "")"
			PONTO=0
		fi
	fi
	
	PONTOS=$(($PONTOS + $PONTO))
done < /tmp/corrige_usuarios

./log.sh -bold "\n SOMA: $PONTOS Pts"
echo $PONTOS >> /tmp/pontos_squid

exit 0
