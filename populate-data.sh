#! /bin/bash

# sleep 36000

until kinit -kt /var/keytabs/hdfs.keytab hdfs/nn1.example.com; do sleep 2; done

until kinit -kt /var/keytabs/hdfs.keytab hdfs/nn2.example.com; do sleep 2; done

until (echo > /dev/tcp/nn1.example.com/9000) >/dev/null 2>&1; do sleep 2; done


hdfs dfsadmin -safemode wait


hdfs dfs -mkdir -p /user/hdfs/
hdfs dfs -copyFromLocal /people.json /user/hdfs
hdfs dfs -copyFromLocal /people.txt /user/hdfs

hdfs dfs -chmod -R 755 /user/hdfs
hdfs dfs -chown -R hdfs /user/hdfs


sleep 30
