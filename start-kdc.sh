#! /bin/bash

# krb5kdc -n

rm -rf /var/keytabs/*.keytab
rm -rf /var/keytabs/*.jks

chmod -R 777 /var/nnshared
rm -rf /var/nnshared/*

# 开启iptables端口转发
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A PREROUTING -p udp --dport 8888 -j REDIRECT --to-ports 88

# 创建数据库
# /usr/sbin/kdb5_util -P changeme create -s
/usr/sbin/kdb5_util -P 123456 create -s

## password only user
# 生成随机key的principal 
/usr/sbin/kadmin.local -q "addprinc -pw 123456 -kvno 1 HTTP/server.example.com"
/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/server.keytab -norandkey HTTP/server.example.com"

/usr/sbin/kadmin.local -q "addprinc -pw 123456 -kvno 1 ubuntu/admin"
/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/admin.keytab -norandkey ubuntu/admin"

/usr/sbin/kadmin.local -q "addprinc -pw 123456 -kvno 1 hdfs/nn1.example.com"
/usr/sbin/kadmin.local -q "addprinc -pw 123456 -kvno 1 HTTP/nn1.example.com"
/usr/sbin/kadmin.local -q "addprinc -pw 123456 -kvno 1 hdfs/nn2.example.com"
/usr/sbin/kadmin.local -q "addprinc -pw 123456 -kvno 1 HTTP/nn2.example.com"
/usr/sbin/kadmin.local -q "addprinc -pw 123456 -kvno 1 hdfs/dn1.example.com"
/usr/sbin/kadmin.local -q "addprinc -pw 123456 -kvno 1 HTTP/dn1.example.com"

/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/hdfs.keytab -norandkey hdfs/nn1.example.com"
/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/hdfs.keytab -norandkey HTTP/nn1.example.com"
/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/hdfs.keytab -norandkey hdfs/nn2.example.com"
/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/hdfs.keytab -norandkey HTTP/nn2.example.com"
/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/hdfs.keytab -norandkey hdfs/dn1.example.com"
/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/hdfs.keytab -norandkey HTTP/dn1.example.com"

chown hdfs /var/keytabs/hdfs.keytab

# keystore
keytool -genkey -alias example.com -keyalg rsa \
     -dname "CN=dn1.example.com,CN=nn1.example.com,CN=nn2.example.com,ou=xxx,o=xxx,l=Beijing,st=Beijing,c=CN" \
     -ext "SAN=dns:nn1.example.com,dns:nn2.example.com,dns:dn1.example.com" \
     -keypass changeme \
     -keystore /var/keytabs/hdfs.jks \
     -storepass changeme \
     -storetype JKS

# keytool -genkey -alias dn1.example.com -keyalg rsa \
#     -dname "CN=dn1.example.com,ou=xxx,o=xxx,l=Beijing,st=Beijing,c=CN" \
#     -ext "SAN=dns:dn1.example.com,ip:172.33.0.23" \
#     -keypass changeme \
#     -keystore /var/keytabs/hdfs.jks \
#     -storepass changeme \
#     -storetype JKS
# keytool -genkey -alias nn.example.com -keyalg rsa \
#     -dname "cn=nn.example.com,ou=xxx,o=xxx,l=Beijing,st=Beijing,c=CN" \
#     -ext "SAN=dns:nn.example.com,ip:172.33.0.22" \
#     -keypass changeme \
#     -keystore /var/keytabs/hdfs.jks \
#     -storepass changeme \
#     -storetype JKS

# truststore
keytool -export -alias example.com -storepass changeme \
   -file /var/keytabs/example.com.cert \
   -keystore /var/keytabs/hdfs.jks
# keytool -export -alias dn1.example.com -storepass changeme \
#     -file /var/keytabs/dn1.example.com.cert \
#     -keystore /var/keytabs/hdfs.jks
# keytool -export -alias nn.example.com -storepass changeme \
#     -file /var/keytabs/nn.example.com.cert \
#     -keystore /var/keytabs/hdfs.jks
keytool -import -v -trustcacerts -alias example.com \
    -file /var/keytabs/example.com.cert \
    -keystore /var/keytabs/truststore.jks \
    -storepass changeme \
    -keypass changeme \
    -noprompt
# keytool -import -v -trustcacerts -alias dn1.example.com \
#     -file /var/keytabs/dn1.example.com.cert \
#     -keystore /var/keytabs/truststore.jks \
#     -storepass changeme \
#     -keypass changeme \
#     -noprompt
# keytool -import -v -trustcacerts -alias nn.example.com \
#     -file /var/keytabs/nn.example.com.cert \
#     -keystore /var/keytabs/truststore.jks \
#     -storepass changeme \
#     -keypass changeme \
#     -noprompt

chmod 700 /var/keytabs/hdfs.jks
chown hdfs /var/keytabs/hdfs.jks
chmod 700 /var/keytabs/truststore.jks
chown hdfs /var/keytabs/truststore.jks

# 配置端口转发
# echo 1 > /proc/sys/net/ipv4/ip_forward 
# iptables -t nat -A PREROUTING -p udp --dport 8888 -j REDIRECT --to-ports 88

# echo "*/admin@EXAMPLE.COM    *" > /etc/krb5kdc/kadm5.acl
echo "*/admin@EXAMPLE.COM    xe" >> /etc/krb5kdc/kadm5.acl



/usr/sbin/kadmin.local -q "addprinc  -pw 123456 -kvno 1 host/kerberos.example.com"
/usr/sbin/kadmin.local -q "addprinc  -pw 123456 -kvno 1 host/kerberos-2.example.com"

/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/host.keytab -norandkey host/kerberos.example.com"
/usr/sbin/kadmin.local -q "ktadd -k /var/keytabs/host.keytab -norandkey host/kerberos-2.example.com"

echo "host/kerberos.example.com@EXAMPLE.COM" > /etc/krb5kdc/kpropd.acl
echo "host/kerberos-2.example.com@EXAMPLE.COM" >> /etc/krb5kdc/kpropd.acl

# /usr/sbin/kadmind
service krb5-admin-server start

krb5kdc -n &

# until kdb5_util dump /var/lib/krb5kdc/dumpfile; do sleep 5; done
# until kprop -f /var/lib/krb5kdc/dumpfile -s /var/keytabs/host.keytab kerberos-2.example.com; \
#       do sleep 5; done

# echo "* * * * * echo \"hello\" >> /cron.txt " >> /var/spool/cron/crontabs/root
#echo "* * * * * root echo \"hello\" >> /cron.txt " >> /etc/crontab
echo "* * * * * root /usr/sbin/kdb5_util dump /var/lib/krb5kdc/dumpfile && \
     /usr/sbin/kprop -r EXAMPLE.COM -f /var/lib/krb5kdc/dumpfile -s /var/keytabs/host.keytab \
     kerberos-2.example.com" >> /etc/crontab
service cron start
# crontab /var/spool/cron/crontabs/root

wait






