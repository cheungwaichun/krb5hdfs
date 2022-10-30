#! /bin/bash

## TEAR DOWN CONTAINERS
docker container rm dn1.example -f
docker container rm nn1.example -f
docker container rm nn2.example -f
docker container rm kerberos.example -f
docker container rm kerberos-2.example -f
docker container rm datapopulator.example -f

## TEAR DOWN IMAGES
docker rmi hadoopkerberos_dn1 --force
docker rmi hadoopkerberos_nn1 --force
docker rmi hadoopkerberos_nn2 --force
docker rmi hadoopkerberos_kerberos --force
docker rmi hadoopkerberos_kerberos-2 --force
docker rmi hadoopkerberos_datapopulator --force

## TEAR DOWN VOLUME (THIS IS IMPORTANT FOR NEW KEYTABS)
docker volume rm hadoopkerberos_server-keytab
