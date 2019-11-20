sed -e /^s*#.*$/d -e /^s*$/d /etc/squid/squid.conf
#./comandos.sh /etc/squid/squid.conf.default | sed  /acl Safe_ports port 21s*#.*$/d
#./comandos.sh /etc/squid/squid.conf.default | sed  /acl Safe_ports port 21.*/d
cat /etc/squid/squid.conf | egrep "^maximum_object_size" | sed s/[a-zA-Z_\s]//g
cat /etc/squid/squid.conf | egrep "^maximum_object_size" | cut -f2-3 -d 
N=$(cat /etc/squid/squid.conf | egrep "^maximum_object_size" | awk {print })
[ $N == "258MB" ]
