#!/bin/bash

SQUID_CONF=$1

# Obtém as configurações do gabarito
./obtem_config.sh IGNORAR_ACLS > /tmp/corrige_acl


# Altera os caracteres * por .*, / por \\/ no gabarito
sed -i 's/*/.*/g' /tmp/corrige_acl
sed -i 's#/#\\\\/#g' /tmp/corrige_acl


# Obtém apenas ACL's do aluno
grep "acl" $SQUID_CONF > /tmp/squid_acls


# Remove todas as ACL's do aluno que devem ser ignoradas, 
# de acordo com o gabarito.
while read ACL_IGNORE; do
	sed -i "/${ACL_IGNORE}$/d" /tmp/squid_acls
done < /tmp/corrige_acl


# Exibe apenas as ACL's importantes do aluno
./log.sh -table-title "ACL'S DO ALUNO"
while read ACL; do
	printf '\t%-2s %-45s\n' "|" "$ACL"
done < /tmp/squid_acls

exit 0

