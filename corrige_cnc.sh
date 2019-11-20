#!/bin/bash

systemctl status squid.service &> /dev/null
ISACTIVE=$?

# Verifica se o squid.service existe
if [ $ISACTIVE -eq 4 ]
then
	./log.sh -e 'squid.service não foi encontrado'
	exit $ISACTIVE

# Se não estiver ativado inicia o serviço
elif [ $ISACTIVE -ne 0 ]
then	
        systemctl start squid.service &> /dev/null
        ISACTIVE=$?
fi



# Verifica se o squid foi iniciado, mesmo que manualmente
if [ $ISACTIVE -ne 0 ]
then
	./log.sh -e 'squid.service não pôde ser ativado'
else
	./log.sh -c 'squid.service está ativo'
fi


 # Verifica se o Squid está habilitado
[ $(systemctl list-unit-files | grep squid.service | awk '{print $2}') =  'enabled' ]
[ $? -ne 0 ] && ./log.sh -i 'squid.service nao está habilitado para iniciar com o sistema!'

exit $ISACTIVE



