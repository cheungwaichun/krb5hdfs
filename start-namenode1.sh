#! /bin/bash

until ls /var/nnshared; do sleep 2; done

until kinit -V -kt /var/keytabs/hdfs.keytab hdfs/nn1.example.com; do sleep 2; done

echo "KDC is up and ready to go... starting up"

kdestroy

hdfs namenode -format
hdfs namenode -initializeSharedEdits -force

hdfs namenode &

until kinit -V -kt /var/keytabs/hdfs.keytab hdfs/nn1.example.com; do sleep 2; done
until hdfs haadmin -transitionToActive nn1; do sleep 2; done

wait
