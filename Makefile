COMPOSE ?= docker compose

start:
	make stop rm || true
	docker run -it \
		-p 5432:5432 \
		-e POSTGRES_PASSWORD=password \
		--name data-salesdb \
		data-salesdb

build:
	docker build . -t data-salesdb

stop:
	docker stop data-salesdb

rm:
	docker rm data-salesdb

bash:
	docker run --rm -it data-salesdb bash

compose-build:
	$(COMPOSE) build

compose:
	$(COMPOSE) up --abort-on-container-exit

compose-down:
	$(COMPOSE) down -v --remove-orphans

compose-logs:
	$(COMPOSE) logs -f

compose-ps:
	$(COMPOSE) ps

compose-bash:
	$(COMPOSE) run --rm postgres bash

compose-attach:
	$(COMPOSE) exec postgres bash
