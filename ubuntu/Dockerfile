#FROM ubuntu:18.04
FROM ubuntu:20.04

#RUN sed -i s@/archive.ubuntu.com/@/192.168.88.11/@g /etc/apt/sources.list && \
#    sed -i s@/security.ubuntu.com/@/192.168.88.11/@g /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y krb5-kdc krb5-admin-server krb5-user krb5-config
RUN apt-get install -y default-jdk jsvc libcommons-daemon-java
RUN apt-get install -y telnet telnetd vim ssh curl net-tools iputils-ping netcat iptables
RUN apt-get install -y krb5-kpropd
RUN apt-get install -y cron

RUN sed -i -e 's/#//' -e 's/default_ccache_name/# default_ccache_name/' /etc/krb5.conf
# 替换kerberos 默认tcp端口为8888
# RUN sed -i -e 's/kerberos\t88\/tcp/kerberos\t8888\/tcp/g' /etc/services

RUN useradd -u 1098 -m hdfs && mkdir /home/hdfs/.ssh

# 配置hadoop
COPY hadoop-2.10.1.tar.gz /
# RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-2.10.1/hadoop-2.10.1.tar.gz
RUN tar -xzvf ./hadoop-2.10.1.tar.gz && \
    mv /hadoop-2.10.1 /hadoop && \
    rm ./hadoop-2.10.1.tar.gz
RUN chown -R -L hdfs /hadoop

COPY krb5.conf /etc/krb5.conf
RUN mkdir /etc/krb5.conf.d/

COPY core-site.xml /hadoop/etc/hadoop/
COPY hdfs-site.xml /hadoop/etc/hadoop/
COPY ssl-server.xml /hadoop/etc/hadoop/
COPY yarn-site.xml /hadoop/etc/hadoop/
COPY ssl-client.xml /hadoop/etc/hadoop/
COPY ssh/id_rsa /home/hdfs/.ssh/id_rsa
COPY ssh/id_rsa.pub /home/hdfs/.ssh/id_rsa.pub
COPY ssh/authorized_keys /home/hdfs/.ssh/authorized_keys

RUN chmod -R 700 /home/hdfs/.ssh && \
    chown -R hdfs:hdfs /home/hdfs/.ssh && \
    chmod 644 /home/hdfs/.ssh/id_rsa.pub && \
    chmod 600 /home/hdfs/.ssh/id_rsa

# COPY start-namenode.sh /
# COPY start-datanode.sh /
# COPY populate-data.sh /
# COPY start-kdc.sh /

COPY people.json /
COPY people.txt /

RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=/hadoop/bin:$PATH
ENV HADOOP_CONF_DIR=/hadoop/etc/hadoop
