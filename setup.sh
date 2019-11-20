

sshpass -p admin scp -r ../Corrige_Squid root@192.168.0.37:~/
sshpass -p admin ssh root@192.168.0.37 -t 'cd ~/Corrige_Squid; /bin/bash corrige_squid.sh; /bin/bash' 
