COMPOSE ?= docker compose

.PHONY: build test

start:
	make stop rm || true
	docker run -it \
		-p 5432:5432 \
		-e POSTGRES_PASSWORD=password \
		--memory 1536m --memory-swap 1536m --shm-size 256m \
		--tmpfs /var/lib/postgresql/tmp:size=512m \
		--name data-salesdb \
		data-salesdb

build:
	docker build . -t data-salesdb

# Start the image and compare row counts with test/expected_counts.tsv.
test: build
	test/smoke.sh data-salesdb

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
