#!/bin/bash


#create the kafka dummy keystore and truststore(change the details if required inside create-ssl-certificates.sh file
./create-selfsigned-certificates.sh

#execute the pre-requisites script to create the namespace, secrets and configmaps required by the deployment
./prerequisite.sh

#install the helm chart to create the single kafka and zookeeper server
helm install kafkahlm .

#fetch the kubernetes node ip where kafka and zookeeper pod is deployed
nodeip=`kubectl get node -l appname=kafka | grep -v NAME | awk -F ' ' '{print $1}'`

#update values.yaml with the correct kubernetes node ip 
sed "s/x.x.x.x/$nodeip/g" values.yaml > values1.yaml
mv values1.yaml values.yaml
#NOTE: The script is tested on max os, in case sed commands gives error, please correct the syntax as per the need
#upgrade helm release to set the proper ip for kafka advertised listener
helm upgrade kafkahlm .

echo ""
echo ""
echo "##################################################################"
echo "Broker PLAINTEXT endpoint is $nodeip:30502"
echo ""
echo "Broker SASL_SSL endpoint is $nodeip:30503"
echo ""
echo "Zookeeper endpoint is $nodeip:30501"
echo ""
echo "Kafka-connect endpoint is $nodeip:30506"
echo ""
echo "Client needs to use the files/client-truststore and password
present in files/client-truststore-password, and the user 'testkafka' 
to connect with kafka, the password for the user can be found
inside files/client-jaas.conf. A sample client properties file 
can be found at files/client.properties"
echo ""
echo "A super user 'admin' is created, the password can be found inside
files/kafka-jaas.conf."
echo ""
echo "A user 'testkafka' is created' for producer and consumer clients."
echo ""
echo "Network needs be allowed to enable connection with the nodeports
on the kubernetes node from client machines"
echo "###################################################################"
