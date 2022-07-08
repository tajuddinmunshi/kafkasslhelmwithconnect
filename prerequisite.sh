#!/bin/bash

#create namespace
kubectl create namespace kafkahelm

#create secrets for kafka keystore
kubectl create secret generic keystore-secret-name --from-file=files/kafka-keystore -n kafkahelm

#create secret for kafka truststore
kubectl create secret generic truststore-secret-name --from-file=files/kafka-truststore -n kafkahelm

#create secret for kafka key password
kubectl create secret generic keypass-secret-name --from-file=files/key-password -n kafkahelm

#create secret for kafka keystore password
kubectl create secret generic keystorepass-secret-name --from-file=files/keystore-password -n kafkahelm

#create secret for kafka truststore password
kubectl create secret generic truststorepass-secret-name --from-file=files/truststore-password -n kafkahelm

#create secret for kafka jaas file
kubectl create secret generic kafka-jaas-secret-name --from-file=files/kafka-jaas.conf -n kafkahelm

#create secret for zookeeper jaas file
kubectl create secret generic zookeeper-jaas-secret-name --from-file=files/zookeeper-jaas.conf -n kafkahelm

#create secret for connect truststore password
kubectl create secret generic connect-pass-secret-name --from-literal=truststorepass=pass123 -n kafkahelm

#create secret for connect jaas file
kubectl create secret generic connect-jaas-secret-name --from-file=files/client-jaas.conf -n kafkahelm

#create secret for connect truststore file
kubectl create secret generic connect-truststore-secret-name --from-file=files/client-truststore -n kafkahelm

#create node label for pods to deploy based on nodeLabels
nodeid=`kubectl get nodes -o wide | grep -v master | grep -v NAME | awk -F ' ' '{print $1}'`
kubectl label nodes $nodeid appname=kafka

