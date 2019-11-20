#!/bin/bash

PARAM=$1

./remove_comentarios.sh ./corrige_squid.conf > /tmp/corrige_squid

# 1- Obtém as linhas que estão entre: PARAM { }
# 2- Remove primeira e ultima linha
sed -n $(echo '/^'$PARAM'/,/^}/p') /tmp/corrige_squid | sed -e '1d' -e '$d'
