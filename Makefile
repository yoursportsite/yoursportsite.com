DOCKER=docker
TAG=yoursportsite-marketing:latest

build:
	$(DOCKER) build --tag $(TAG) .

serve:
	$(DOCKER) run --publish 4000:4000 --rm --volume $(shell pwd):/usr/src/app --workdir /usr/src/app $(TAG)
