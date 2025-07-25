DOCKER := docker
TAG := yoursportsite-marketing:latest

.PHONY: install build serve

all: install build serve

install:
	$(DOCKER) run --rm --tty --volume $(shell pwd):/usr/src/app --workdir /usr/src/app node:22 npm install

build: install
	$(DOCKER) build --tag $(TAG) .

serve: build
	$(DOCKER) run --publish 4000:4000 --rm --tty --volume $(shell pwd):/usr/src/app --workdir /usr/src/app $(TAG)
