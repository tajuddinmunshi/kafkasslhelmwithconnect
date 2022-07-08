# A single node Kafka, Zookeeper and connect cluster on Kubernetes using Helm

Introduction: 
This creates a single node sasl_ssl Kafka, zookeeper and a connect cluster.

Installation: 
The script install.sh is used for the end to end deployment of the kafka, zookeeper and connect cluster.

Installation description
The script will create/execute the below required pre-requisites:
A dummy CA.
A dummy Kafka keystore and truststore.
Password files required by kubernetes to create secrets. 
A kubernetes namespace "kafkahelm".
Kubernetes secrets.
Add a label to the kubernetes node so that the pods are assigned to the same node after restart.
The helm chat deployment.
Update the kafka advertised ip in values.yaml with the correct ip of the kubernetes node whare the pod is deployed.
Upgrade the helm release to reflect the updated kafka advertised ip.  
Display the required information about broker, zookeeper, users and additional information required by clients.

Uninstall and cleanup:
The script uninstall.sh is used to uninstall the helm release and deletes the kubernetes objects and related files.

Cleanup description:
The script will uninstall/delete the below:
The kafka keystore and truststore.
The password files.
Kubernetes secrets.
Uninstall the helm release.
Delete the kubernetes namespace "kafkahelm".
Revert back the changes made to values.yaml by installation script.
Remove the kubernetes node label.

Additional script description:
create-selfsigned-certificates.sh: The install.sh script uses this script in the background
to create the ssl pre-requisites like generating dummy CA, keystore, truststore files and put it under 
files folder. The values inside this script can be changes as required to generate different CA, keystore 
and truststore. It also creates the password files under files folder which are required by kubernetes secrets.

prerequisite.sh: The install.sh script uses this script to label the node and create the kubernetes objects.



Note: kafka jaas, zookeeper jaas are predefines under files folder.
This is required by kubernetes to create secrets.
A client.properties file is also predefined inside files folder,
as a guide for clients. The client user and passwords could be found in these files.
The passwords for keystore,truststore and key can be found under files folder after execution of install script.


Sample file contents:

example content of key-password:
password-for-key

example content of kafka-jaas.conf:
KafkaServer {
   org.apache.kafka.common.security.plain.PlainLoginModule required
   username="admin"
   password="<admin-password>"
   user_admin="admin-secret"
   user_testkafka="<user-password>";
};
Client {
   org.apache.kafka.common.security.plain.PlainLoginModule required
   username="testkafka"
   password="<user-password>";
};


example content of zookeeper-jaas.conf:
Server {
    org.apache.zookeeper.server.auth.DigestLoginModule required
    user_admin="admin-password";
};
