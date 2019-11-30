#!/bin/bash

SQUID_CONF=$1

# Obtém as configurações do gabarito
./obtem_config.sh PARAMETROS > /tmp/corrige_params

#./log.sh -table-title "PARÂMETRO"  "ERRO"

PONTOS=0

while read CONF; do

	PONTO=$(echo $CONF | awk -F")" '{print $1}' | sed -e "s/[^0-9\.]//g") 
	PARAM=$(echo $CONF | awk -F")" '{first = $1; $1 = ""; print $0}' | awk '{print $2}')
	# Obtém o valor do parametro, mesmo que seja mais de um
	VALOR=$(echo $CONF | awk -F")" '{first = $1; $1 = ""; print $0}' | awk '{first = $1; $1 = ""; print $0}')
	
	CONF_ALUNO=$(cat $SQUID_CONF | grep $PARAM)
	ENCONTRADO=$?
	VALOR_ALUNO=""

	if [ $ENCONTRADO -eq 0 ]; then
		VALOR_ALUNO=$(echo $CONF_ALUNO | awk '{first = $1; $1 = ""; print $0}')
	fi


	if [ $ENCONTRADO -eq 0 ] && [ "$VALOR" = "$VALOR_ALUNO" ]; then
		./log.sh -certo "$(printf '%-50s %s\n' "$CONF" "" )" 
	else
		DEBUG=$( ([ $ENCONTRADO -eq 0 ] && echo "[$VALOR_ALUNO ]") || echo "[ NÃO ENCONTRADO ]" )
		./log.sh -errado "$(printf '%-50s %s\n' "$CONF"  "$DEBUG")"
		PONTO=0
	fi

	PONTOS=$(($PONTOS + $PONTO))

done < /tmp/corrige_params

./log.sh -bold "\n SOMA: $PONTOS Pts"
echo $PONTOS >> /tmp/pontos_squid

exit 0

