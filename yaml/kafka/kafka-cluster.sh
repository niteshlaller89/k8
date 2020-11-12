#! /bin/bash
helm repo list
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

#helm delete kafka-release --namespace kafka

# helm install kafka-release --namespace kafka \
#  --set persistence.enabled=false \
#  --set zookeeper.persistence.enabled=false \
#  --set metrics.kafka.enabled=true \
#  --set metrics.jmx.enabled=true \
#  --set zookeeper.metrics.enabled=true \
#  --set replicaCount=2 \
#   bitnami/kafka


##use values.yaml for kafka cluster deployment
## 2 brokers, 1 replication
## 1 zookeeper
helm install kafka-release --namespace kafka -f values.yaml \
 --set zookeeper.persistence.enabled=false \
 --set zookeeper.persistence.enabled=false bitnami/kafka

##get external ips of your cluster
kubectl exec -it kafka-release-1 -n kafka -- cat /opt/bitnami/kafka/config/server.properties | grep advertised.listeners


##kafka cluster manager
#helm delete kafka-manager-release -n kafka
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update
helm install kafka-manager-release -n kafka --set zkHosts=kafka-release-zookeeper:2181 stable/kafka-manager
export POD_NAME=$(kubectl get pods --namespace kafka -l "app=kafka-manager,release=kafka-manager-release" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:9000


##kafka testing
kubectl run kafka-release-client --restart='Never' --image docker.io/bitnami/kafka:2.6.0-debian-10-r30 --namespace kafka --command -- sleep 10000
kubectl exec --tty -i kafka-release-client -n kafka -- bash
kafka-console-producer.sh \
 --broker-list kafka-release-0.kafka-release-headless.kafka.svc.cluster.local:9092,kafka-release-1.kafka-release-headless.kafka.svc.cluster.local:9092 \
 --topic sample
kafka-console-consumer.sh \
 --bootstrap-server kafka-release.kafka.svc.cluster.local:9092 \
 --topic sample \
 --from-beginning


## IMPORTANT ##
########## >>>>>>>>> CHANGE FD LIMITS ON CLUSTER NODES <<<<<<<<<<<<< ###############
## /etc/security/limits.conf
## add below entries to this file: 
## <username> soft nofile 8192
## <username> hard nofile 20000


#### DON'T REBOOT NODE AND MASTER ON SAME TIME, LET NODE COMES UP AND THEN REBOOT MASTER ####