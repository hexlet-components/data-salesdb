start:
	docker run -it \
		-p 5432:5432 \
		-v $(CURDIR)/scripts:/docker-entrypoint-initdb.d \
		-e POSTGRES_PASSWORD=password \
		--name data-salesdb \
		data-salesdb

test-build:
	docker build . -t data-salesdb

stop:
	docker stop data-salesdb
