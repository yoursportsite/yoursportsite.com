DOCKER := docker
TAG := yoursportsite-marketing:latest

.PHONY: install build serve deploy

all: install build serve

install:
	$(DOCKER) run --rm --tty --volume $(shell pwd):/usr/src/app --workdir /usr/src/app node:22 npm install

build:
	$(DOCKER) build --tag $(TAG) .

serve:
	$(DOCKER) run --publish 4000:4000 --rm --tty --volume $(shell pwd):/usr/src/app --workdir /usr/src/app $(TAG)

deploy:
	npm install
	bin/premier-league-table.rb
	bin/national-league-tables.rb
	bundle exec jekyll build
