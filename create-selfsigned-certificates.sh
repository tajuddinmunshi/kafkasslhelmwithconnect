#/bin/bash
#Description: This script creates a dummy CA for generating self signed certificates. It also creates a keystore and truststore 
that can be used for the kafka cluster for development purpose.

keypass=pass123
keystorepass=pass123
truststorepass=pass123
#create dummy CA
openssl req -new -newkey rsa:4096 -days 365 -x509 -subj "/CN=Kafka-Dummy-CA" -keyout files/ca-key -out files/ca-cert -nodes

#generate a dummy keystore
rm -rf files/kafka-keystore #removing keystore if already present 
keytool -genkeypair -alias kafka-ssl -keyalg RSA -keysize 2048 -keypass $keypass -storepass $keystorepass -validity 9999 -keystore files/kafka-keystore -ext SAN=DNS:localhost,IP:127.0.0.1 -dname "CN=localhost, OU=Organizational Unit, O=Organization, L=Location, ST=State, C=Country"

#create self sign certificate
keytool -keystore files/kafka-keystore -alias kafka-ssl -certreq -file files/cert-file -storepass $keystorepass -keypass $keypass

#Sign the cert with the CA create to generate a self signed cert
openssl x509 -req -CA files/ca-cert -CAkey files/ca-key -in files/cert-file -out files/cert-signed -days 365 -CAcreateserial -passin pass:$keypass

#create a dummy truststore and import the ca root cert:
rm -rf files/kafka-truststore #removing truststore if already present
keytool -keystore files/kafka-truststore -alias ca-root -import -file files/ca-cert -storepass $truststorepass -keypass $keypass -noprompt

#Import the signed certificate to truststore:
keytool -keystore files/kafka-truststore -alias signed-cert -import -file files/cert-signed -storepass $truststorepass -keypass $keypass -noprompt

#import ca root cert to keystore:
keytool -keystore files/kafka-keystore -alias ca-root -import -file files/ca-cert -storepass $keystorepass -keypass $keypass -noprompt

#Import self-signed cert to keystone:
keytool -keystore files/kafka-keystore -alias signed-cert -import -file files/cert-signed -storepass $keystorepass -keypass $keypass -noprompt

#removing the certs apart from keystore and truststore
rm -rf files/ca-key files/ca-cert files/cert-file files/cert-signed files/ca-cert.srl

#creating client truststore file to be used by connect and clients
cp -rp files/kafka-truststore files/client-truststore

#creating password files required by kubernetes secrets
rm -rf files/truststore-password  #deleting old passwordfile if present
rm -rf files/key-password #deleting old passwordfile if present
rm -rf files/keystore-password ##deleting old passwordfile if present
echo "$keypass" > files/key-password
echo "$keystorepass" > files/keystore-password
echo "$truststorepass" > files/truststore-password
echo "$truststorepass" > files/client-truststore-password
chmod 644 files/key-password files/keystore-password files/truststore-password files/client-truststore-password
echo "###############################################################################################"
echo "NOTES:"
echo "The kafka keystore is present under files/kafka-keystore"
echo "The kafka truststore is present under files/kafka-truststore"
echo "The client truststore is present under files/client-truststore, 
corresponding client truststore password can be found in files/client-truststore-password),
provide the client-truststore and password to client who wants to connect to this kafka"
echo "###############################################################################################"
