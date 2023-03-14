start:
	docker run -it \
		-v $(CURDIR):/docker-entrypoint-initdb.d \
		-p 5432:5432 \
		-e POSTGRES_PASSWORD=password \
		data-salesdb

build:
	docker build . -t data-salesdb
