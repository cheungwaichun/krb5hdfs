#! /bin/bash


rm -rf /var/keytabs/*.keytab
rm -rf /var/keytabs/*.jks

chmod -R 777 /var/nnshared
rm -rf /var/nnshared/*

# 开启iptables端口转发
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A PREROUTING -p udp --dport 8888 -j REDIRECT --to-ports 88

# 创建数据库
/usr/sbin/kdb5_util create -s



echo "host/kerberos.example.com@EXAMPLE.COM" > /etc/krb5kdc/kpropd.acl
echo "host/kerberos-2.example.com@EXAMPLE.COM" >> /etc/krb5kdc/kpropd.acl

until \
      /usr/sbin/kadmin -p ubuntu/admin -w 123456 -q \
          "ktadd -k /var/keytabs/host.keytab -norandkey host/kerberos-2.example.com"; \
      do sleep 5;done
      
apt install krb5-kpropd

krb5kdc -n
