#!/bin/bash

SQUID_CONF=$1
HOST_PROXY=$2
PROXY_PORT=$3
SITE_TEST_AUTH="www.dontpad.com/guilherme"

# Obtém as configurações do gabarito
./obtem_config.sh USUARIOS > /tmp/corrige_usuarios

# Obtém apenas ACL's e HTTP_ACCESS do aluno
grep "acl" $SQUID_CONF > /tmp/squid_acls
grep "http_access" $SQUID_CONF > /tmp/squid_http_access

#./log.sh -table-title "Usuário" "CRIADA ACL" "USADO EM HTTP_ACCESS"

PONTOS=0
while read CONF_USUARIO; do

	PONTO=$(echo $CONF_USUARIO | awk -F")" '{print $1}' | sed -e "s/[^0-9\.]//g")
	CONF_USER=$(echo $CONF_USUARIO | awk -F")" '{first = $1; $1 = ""; print $0}')
        USUARIO=$(echo $CONF_USER | awk '{print $1}')
	SENHA=$(echo $CONF_USER | awk '{print $2}')
	
	#echo $HOST_PROXY $PROXY_PORT $CONF_USER $USUARIO $SENHA

	curl -I -s -x http://$HOST_PROXY:$PROXY_PORT \
                --proxy-user $USUARIO:$SENHA \
               -L $SITE_TEST_AUTH | head -n1 | grep '407' &> /dev/null
	AUTH_REQUIRE=$?
	
	ACL_SEARCH=$(echo -e "acl .* proxy_auth $USUARIO")
	ACL_USER_SQUID=$(cat /tmp/squid_acls | sed -n "/$ACL_SEARCH/p")
	ACL_USER_SQUID=$(echo $ACL_USER_SQUID | awk '{print $2}')

	ACL_USER_SQUID=$(( [ -z $ACL_USER_SQUID ] && echo "" ) || echo "[ $ACL_USER_SQUID ]")

	if [ $AUTH_REQUIRE -eq 0 ]; then
		./log.sh -errado "$(printf '%-50s %-20s %-10s\n' "$CONF_USUARIO" "$ACL_USER_SQUID" "[ USUÁRIO NÃO CRIADO OU SENHA INCORRETA ]")"
		PONTO=0
	else
		./log.sh -certo "$(printf '%-50s %-20s %-10s\n' "$CONF_USUARIO" "$ACL_USER_SQUID" "[ USUÁRIO CRIADO ]")"
	fi

	PONTOS=$(($PONTOS + $PONTO))

done < /tmp/corrige_usuarios

./log.sh -bold "\n SOMA: $PONTOS Pts"
echo $PONTOS >> /tmp/pontos_squid

exit 0
