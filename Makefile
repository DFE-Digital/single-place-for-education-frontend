.PHONY: down
down:
	docker-compose down

.PHONY: setup
setup:
	docker-compose build

.PHONY: serve
serve: down setup
	docker-compose run --rm --service-ports web

