#!/usr/bin/env bash

DOCKER_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $DOCKER_DIR && docker build -f Dockerfile --tag babbili/py-app:cfb923622 ../

docker push babbili/py-app:cfb923622

cd -
