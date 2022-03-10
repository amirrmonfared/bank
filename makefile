postgres: 
	docker run --name postgres14 -p 8081:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=password -d postgres:14-alpine

createdb:
	docker exec -it postgres14 createdb --username=root --owner=root bank

dropdb:
	docker exec -it postgres14 dropdb --username=root bank

root:
	docker exec -it postgres14 /bin/sh

psql:
	docker exec -it postgres14 psql -U root -d bank

migrateup: 
	migrate -path db/migration -database "postgresql://root:password@localhost:8081/bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:password@localhost:8081/bank?sslmode=disable" -verbose down

sqlc:
	docker run --rm -v C:\Users\amir\.vscode\bank:/src -w /src kjconroy/sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/amirrmonfared/bank/db/sqlc Store

.PHONY: createdb postgres dropdb root psql migrateup migratedown sqlc test server mock