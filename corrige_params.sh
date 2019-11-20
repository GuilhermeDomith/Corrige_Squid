#!/bin/bash

SQUID_CONF="/etc/squid/squid.conf"
./remove_comentarios.sh $SQUID_CONF > /tmp/squid_conf
SQUID_CONF="/tmp/squid_conf"

#CORRIGE_CONF="./corrige_squid.conf"
#./remover_comentarios.sh $CORRIGE_CONF > /tmp/corrige_conf
#CORRIGE_CONF="/tmp/corrige_conf"

#cat $SQUID_CONF

./obtem_config.sh PARAMETROS > /tmp/corrige_params

while read CONF; do

	PARAM=$(echo $CONF | awk '{print $1}')
	# Obtém o valor mesmo que seja mais de um
	VALOR=$(echo $CONF | awk '{first = $1; $1 = ""; print $0}')

	CONF_ALUNO=$(cat $SQUID_CONF | grep $PARAM)
	ENCONTRADO=$?
	VALOR_ALUNO=""

	if [ $ENCONTRADO -eq 0 ]; then
		VALOR_ALUNO=$(echo $CONF_ALUNO | awk '{first = $1; $1 = ""; print $0}')
	fi

	if [ $ENCONTRADO -eq 0 ] && [ "$VALOR" = "$VALOR_ALUNO" ]; then
		./log.sh -c "$CONF"
	else
		DEBUG=$( ([ $ENCONTRADO -eq 0 ] && echo "[VALOR INCORRETO:""$VALOR_ALUNO""]") || echo "[PARÂMETRO NAO ENCONTRADO]" )
		./log.sh -e "$(printf '%-50s %s\n' "$CONF"  "$DEBUG")"
	fi

	#echo -e '\n'

done < /tmp/corrige_params

exit 0

