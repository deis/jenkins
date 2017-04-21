# If DEIS_REGISTRY is not set, try to populate it from legacy DEV_REGISTRY
DEIS_REGISTRY ?= $(DEV_REGISTRY)
IMAGE_PREFIX ?= deis
COMPONENT ?= jenkins
SHORT_NAME ?= $(COMPONENT)

include versioning.mk

check-docker:
	@if [ -z $$(which docker) ]; then \
	  echo "Missing \`docker\` client which is required for development"; \
	  exit 2; \
	fi

build: docker-build
push: docker-push
run: docker-run

docker-build: check-docker
	docker build --rm -t ${IMAGE} .
	docker tag ${IMAGE} ${MUTABLE_IMAGE}

docker-run:
	docker run --rm ${IMAGE}

clean: check-docker
	docker rmi $(IMAGE)

test:
	@echo "No tests to run at this time."

.PHONY: build clean docker-build test
