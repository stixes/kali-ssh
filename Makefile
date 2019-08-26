IMAGE_NAME=kalissh

build:
	docker build -t ${IMAGE_NAME} .

shell:
	docker run -it --rm -v /:/host ${IMAGE_NAME} /bin/bash

start:
	docker run -d --rm --network="host" -v /:/host --name kalissh-dev ${IMAGE_NAME}

stop:
	-docker rm -f kalissh-dev


