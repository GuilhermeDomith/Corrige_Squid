#!/bin/bash

systemctl status squid.service &> /dev/null
ISACTIVE=$?

# Verifica se o squid.service existe
if [ $ISACTIVE -eq 4 ]; then
	./log.sh -errado 'squid.service não foi encontrado'
	exit 1

# Se não estiver ativado inicia o serviço
elif [ $ISACTIVE -ne 0 ]; then	
        systemctl start squid.service &> /dev/null
        ISACTIVE=$?
fi



# Verifica se o squid foi iniciado, mesmo que manualmente
if [ $ISACTIVE -ne 0 ]; then
	./log.sh -errado 'squid.service não pôde ser iniciado'
	exit 1
else
	./log.sh -certo 'squid.service está ativo'
fi


 # Verifica se o Squid está habilitado
[ $(systemctl list-unit-files | grep squid.service | awk '{print $2}') =  'enabled' ]
if [ $? -ne 0 ]; then
	./log.sh -errado 'squid.service nao está habilitado para iniciar com o sistema!'
else
	./log.sh -certo 'squid.service está habilitado para iniciar com o sistema!'
fi


exit 0



