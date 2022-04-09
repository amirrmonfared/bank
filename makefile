postgres: 
	docker run --name postgres14 --network bank-network -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:14-alpine

createdb:
	docker exec -it postgres14 createdb --username=root --owner=root bank

dropdb:
	docker exec -it postgres14 dropdb --username=root bank

root:
	docker exec -it postgres14 /bin/sh

psql:
	docker exec -it postgres14 psql -U root -d bank

migrateupsrv: 
	migrate -path db/migration -database "postgresql://root:A20m01irBaharph79b!@bank.ct386ye9vqsz.eu-west-1.rds.amazonaws.com:5432/bank" -verbose up

migrateup: 
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/bank?sslmode=disable" -verbose up

migrateup1: 
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/bank?sslmode=disable" -verbose down 1

sqlc:
	docker run --rm -v C:\Users\amir\.vscode\courses\bank:/src -w /src kjconroy/sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/amirrmonfared/bank/db/sqlc Store

dockerrun:
	docker run --name bank --network bank-network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:password@postgres14:5432/bank?sslmode=disable" bank:latest

.PHONY: createdb postgres dropdb root psql migrateup migratedown sqlc test server mock migratedown1 migrateup1 dockerrun migrateupsrv