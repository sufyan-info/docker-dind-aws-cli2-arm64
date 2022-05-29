#!/bin/bash

# usage
# exec.sh 1.1

docker build -t docker-dind-aws-cli2-arm64:$1 .
docker tag docker-dind-aws-cli2-arm64:$1 super37/docker-dind-aws-cli2-arm64:$1
docker push super37/docker-dind-aws-cli2-arm64:$1
