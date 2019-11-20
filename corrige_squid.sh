#!/bin/bash

./log.sh -t "CRITÉRIO PARA NÃO CORREÇÃO"
./corrige_cnc.sh

if [ $? -eq 0 ]; then
	./log.sh -t "PARÂMETROS UNICOS"
	./corrige_params.sh
fi

./log.sh -t "CORREÇÃO DO SQUID FINALIZADA!"

