DOCKER_IMAGE_TAG ?= 2
DOCKER_IMAGE_NAME ?= registry
DOCKER_CONTAINER_NAME ?= registry_1

REGISTRY_AUTH ?= htpasswd
REGISTRY_AUTH_HTPASSWD_REALM ?= Registry realm
REGISTRY_AUTH_HTPASSWD_PATH ?= /auth/htpasswd
REGISTRY_HTTP_TLS_CERTIFICATE ?= /certs/server-cert.pem
REGISTRY_HTTP_TLS_KEY ?= /certs/server-key.pem

default: help

help:
	@echo "Usage: 'make <target>' where <target> is one of"
	@echo "  pull            pull docker image"
	@echo "  build           generates new certificate, see cert"
	@echo "  run             run the docker image"
	@echo "  sh              starts a shell inside the running container"
	@echo "  stop            stops the container"
	@echo "  clean           removes the container and wipes image on disk"
	@echo "  cert            generate TLS certificates"

run:
	@echo "Running docker image..."
	docker run --name $(DOCKER_CONTAINER_NAME) --restart=on-failure \
  	-v $(PWD)/auth:/auth \
		-e "REGISTRY_HTTP_SECRET=asdqwe123" \
  	-e "REGISTRY_AUTH=$(REGISTRY_AUTH)" \
  	-e "REGISTRY_AUTH_HTPASSWD_REALM=$(REGISTRY_AUTH_HTPASSWD_REALM)" \
  	-e "REGISTRY_AUTH_HTPASSWD_PATH=$(REGISTRY_AUTH_HTPASSWD_PATH)" \
  	-v $(PWD)/certs:/certs \
  	-e "REGISTRY_HTTP_TLS_CERTIFICATE=$(REGISTRY_HTTP_TLS_CERTIFICATE)" \
  	-e "REGISTRY_HTTP_TLS_KEY=$(REGISTRY_HTTP_TLS_KEY)" \
  	-v $(PWD)/data:/var/lib/registry \
	-p 5000:5000 -d "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)"

shell:
	@echo "Starting bash..."
	docker exec -it $(DOCKER_CONTAINER_NAME) /bin/sh

stop:
	@echo "Stop container..."
	docker stop $(DOCKER_CONTAINER_NAME)

clean:
	@echo "Remove container..."
	docker rm -f $(DOCKER_CONTAINER_NAME)

pull:
	@echo "Pulling images..."
	docker pull "$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)"

cert:
	@make -C ../docker-cert-generator clean all

build:  cert
