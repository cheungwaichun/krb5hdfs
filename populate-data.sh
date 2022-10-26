#! /bin/bash

# sleep 36000

until kinit -kt /var/keytabs/hdfs.keytab hdfs/nn1.example.com; do sleep 2; done

until kinit -kt /var/keytabs/hdfs.keytab hdfs/nn2.example.com; do sleep 2; done

until (echo > /dev/tcp/nn1.example.com/9000) >/dev/null 2>&1; do sleep 2; done


hdfs dfsadmin -safemode wait


hdfs dfs -mkdir -p /user/ifilonenko/
hdfs dfs -copyFromLocal /people.json /user/ifilonenko
hdfs dfs -copyFromLocal /people.txt /user/ifilonenko

hdfs dfs -chmod -R 755 /user/ifilonenko
hdfs dfs -chown -R ifilonenko /user/ifilonenko


sleep 60