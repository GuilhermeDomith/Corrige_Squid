#!/bin/bash

PARAM=$1
CONFIG_FILE=./corrige_squid.conf
TMP_FILE=/tmp/corrige_squid

./remove_comentarios.sh $CONFIG_FILE > $TMP_FILE

# 1- Obtém as linhas que estão entre: PARAM { }
# 2- Remove primeira e ultima linha
cat $TMP_FILE | sed -n $(echo '/^'$PARAM'/,/^}/p') | sed -e '1d' -e '$d' | awk '{print $0}' &> $TMP_FILE

# Obter parâmetro específico das configurações
if [ "$2" = "-p" ]; then
	cat $TMP_FILE | sed -n $(echo '/'$3'.*$/p') &> $TMP_FILE'_2'
	cat $TMP_FILE'_2' &> $TMP_FILE
fi

cat $TMP_FILE
 

