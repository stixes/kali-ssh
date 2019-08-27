IMAGE_NAME=kalissh

build:
	docker build -t ${IMAGE_NAME} .

shell:
	docker run -it --rm -v /:/host ${IMAGE_NAME} /bin/bash

run:
	docker run -it --rm --network="host" -v /:/host --name kalissh-dev ${IMAGE_NAME}

start:
	docker run -d --rm --network="host" -v /:/host --name kalissh-dev ${IMAGE_NAME}

restart: stop start

stop:
	-docker rm -f kalissh-dev


