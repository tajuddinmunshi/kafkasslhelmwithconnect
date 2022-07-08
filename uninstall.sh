#!/bin/bash

#deleting kafka keystore secret
kubectl delete secret keystore-secret-name -n kafkahelm

#deleting kafka truststore secret
kubectl delete secret truststore-secret-name -n kafkahelm

#deleting kafka keypass secret
kubectl delete secret keypass-secret-name -n kafkahelm

#deleting kafka keystorepass secret
kubectl delete secret keystorepass-secret-name -n kafkahelm

#deleting kafka truststorepass secret
kubectl delete secret truststorepass-secret-name -n kafkahelm

#deleting kafka jaas secret
kubectl delete secret kafka-jaas-secret-name -n kafkahelm

#deleting zookeeper jaas secret
kubectl delete secret zookeeper-jaas-secret-name -n kafkahelm

#deleting connect truststore secret
kubectl delete secret connect-truststore-secret-name -n kafkahelm

#deleting connect jaas secret
kubectl delete secret connect-jaas-secret-name -n kafkahelm

#deleting connect truststorepassword secret
kubectl delete secret connect-pass-secret-name -n kafkahelm




#deleting kafka-zookeeper helm deployment
helm uninstall kafkahlm

#deleting namespace
kubectl delete namespace kafkahelm

#deleting kafka-truststore, kafka-keystore client-truststore and password files
rm -rf files/kafka-truststore files/kafka-keystore files/client-truststore files/client-truststore-password files/key-password files/keystore-password files/truststore-password

#reverting ips back to original values inside values.yaml for next installation
sed 's|PLAINTEXT://.*:30502|PLAINTEXT://x.x.x.x:30502|g' values.yaml > values1.yaml
mv values1.yaml values.yaml

sed 's|SASL_SSL://.*:30503|SASL_SSL://x.x.x.x:30503|g' values.yaml > values1.yaml
mv values1.yaml values.yaml 

sed 's|: .*:30503|: x.x.x.x:30503|g' values.yaml > values1.yaml
mv values1.yaml values.yaml

#removing node label created for the deployment
nodeip=`kubectl get node -l appname=kafka | grep -v NAME | awk -F ' ' '{print $1}'`
kubectl label node $nodeip appname-
