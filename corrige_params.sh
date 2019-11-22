#!/bin/bash

SQUID_CONF=$1

# Obtém as configurações do gabarito
./obtem_config.sh PARAMETROS > /tmp/corrige_params

./log.sh -table-title "PARÂMETRO"  "ERRO"

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
		./log.sh -certo "$(printf '%-45s %s\n' "$CONF"  "")" 
	else
		DEBUG=$( ([ $ENCONTRADO -eq 0 ] && echo "[$VALOR_ALUNO ]") || echo "[ NÃO ENCONTRADO ]" )
		./log.sh -errado "$(printf '%-45s %s\n' "$CONF"  "$DEBUG")"
	fi

done < /tmp/corrige_params

exit 0

