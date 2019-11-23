#!/bin/bash

SQUID_CONF=$1

# Obtém as configurações do gabarito
./obtem_config.sh IGNORAR_HTTP_ACCESS > /tmp/corrige_http_access

# Alterar caracteres para criar regex que será usado no sed
# Altera os caracteres * por .*, / por \\/ no gabarito
sed -i 's/*/.*/g' /tmp/corrige_http_access
sed -i 's#/#\\\\/#g' /tmp/corrige_http_access


# Obtém apenas HTTP_ACCESS do aluno
grep "http_access" $SQUID_CONF > /tmp/squid_http_access


# Remove todas as HTTP_ACCESS do aluno que devem ser ignoradas, 
# de acordo com o gabarito.
while read HTTP_ACCESS_IGNORE; do
        sed -i "/${HTTP_ACCESS_IGNORE}$/d" /tmp/squid_http_access
done < /tmp/corrige_http_access


# Exibe apenas as HTTP_ACCESS importantes do aluno
#./log.sh -table-title "HTTP ACCESS DO ALUNO"
while read HTTP_ACCESS; do
        printf ' %-2s %-45s\n' "|" "$HTTP_ACCESS"
done < /tmp/squid_http_access

exit 0

