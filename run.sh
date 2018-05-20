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

## elasticsearch

http://127.0.0.1:9200/
docker run -d -it --name es -p 9200:9200 -p 9300:9300 elasticsearch

## kibana
http://127.0.0.1:5601/app/kibana#/management/kibana/index?_g=()
docker run -d -it --name kibana --link es:elasticsearch -p 5601:5601 kibana

## logstash
docker run -d -it --name logstash -p 5000:5000 logstash -e 'input { tcp { port => 5000 codec => "json" } } output { elasticsearch { hosts => ["192.168.99.100"] index => "micro-%{serviceName}"} }'