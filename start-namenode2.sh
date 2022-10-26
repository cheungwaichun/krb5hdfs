#! /bin/bash

until ls /var/nnshared; do sleep 2; done

sleep 30

until kinit -V -kt /var/keytabs/hdfs.keytab hdfs/nn2.example.com; do sleep 2; done

echo "KDC is up and ready to go... starting up"

kdestroy

hdfs namenode -bootstrapStandby -force
hdfs namenode