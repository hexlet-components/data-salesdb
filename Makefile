start:
	docker run -it \
		-p 5432:5432 \
		-e POSTGRES_PASSWORD=password \
		data-salesdb

test-build:
	docker build . -t data-salesdb

stop:
	docker stop data-salesdb
