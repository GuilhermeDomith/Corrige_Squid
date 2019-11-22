#!/bin/bash

SQUID_CONF=$1

# Obtém as configurações do gabarito
./obtem_config.sh IGNORAR_HTTP_ACCESS > /tmp/corrige_http_access

# Alterar caracteres para criar regex que será usado no sed
# Altera os caracteres * por .*, / por \\/ no gabarito
sed -i 's/*/.*/g' /tmp/corrige_http_access
sed -i 's#/#\\\\/#g' /tmp/corrige_http_access


# Obtém apenas ACL's do aluno
grep "http_access" $SQUID_CONF > /tmp/squid_http_access


# Remove todas as ACL's do aluno que devem ser ignoradas, 
# de acordo com o gabarito.
while read ACL_IGNORE; do
        sed -i "/${ACL_IGNORE}$/d" /tmp/squid_http_access
done < /tmp/corrige_http_access


# Exibe apenas as ACL's importantes do aluno
./log.sh -table-title "HTTP ACCESS DO ALUNO"
while read ACL; do
        printf '\t%-2s %-45s\n' "|" "$ACL"
done < /tmp/squid_http_access

exit 0

