#!/bin/bash

# http://127.0.0.1:8761/ Eureka discovery server
java -jar discovery-service/target/discovery-service.jar

# http://10.0.0.119:2222/accounts
java -jar account-service/target/account-service.jar

# http://127.0.0.1:3333/customers
java -jar customer-service/target/customer-service.jar



# http://127.0.0.1:8765/api/account/accounts
# http://127.0.0.1:8765/api/customer/customers
java -jar gateway-service/target/gateway-service.jar



java -jar zipkin-service/target/zipkin-service-1.0-SNAPSHOT.jar


ELK
http://127.0.0.1:9200/
docker run -d -it --name es -p 9200:9200 -p 9300:9300 elasticsearch


http://127.0.0.1:5601/app/kibana#/management/kibana/index?_g=()
docker run -d -it --name kibana --link es:elasticsearch -p 5601:5601 kibana

docker run -d -it --name logstash -p 5000:5000 logstash -e 'input { tcp { port => 5000 codec => "json" } } output { elasticsearch { hosts => ["elasticsearch:9200"] index => "micro-%{serviceName}"} }'


docker stop logstash kibana es


1) docker network create mynetwork

2)
docker run  -it -p 9200:9200 –name elasticsearch  –network=mynetwork docker.elastic.co/elasticsearch/elasticsearch:5.4.3

3)
docker run -it -p 5000:5000 -e "xpack.monitoring.enabled=false" –network=mynetwork docker.elastic.co/logstash/logstash:5.4.3 -e 'input { tcp { port => 5000 codec => "json" }} output { elasticsearch { hosts => ["elasticsearch:9200"] } }'

4)
docker run -it -p 5601:5601 –network=mynetwork docker.elastic.co/kibana/kibana:5.4.3


docker container rm logstash kibana es

docker network create mynetwork –driver=bridge
docker run -p 9200:9200 -p 9300:9300 –name elasticsearch -d –network mynetwork elasticsearch
docker run -p 5601:5601 –name kibana -d –network mynetwork kibana
docker run -d –network mynetwork –name logstash -p 5000:5000 logstash -e 'input { tcp { port => 5000 codec => "json" } } output { elasticsearch { hosts => ["elasticsearch"] index => "micro-%{serviceName}"} }'