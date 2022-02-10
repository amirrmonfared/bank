package db

import (
	"database/sql"
	"log"
	"os"
	"testing"

	_ "github.com/lib/pq"
)

const (
	dbDriver = "postgres"
	dbSource = "postgresql://root:password@localhost:8081/bank?sslmode=disable"
)

var testQueris *Queries

func TestMain(m *testing.M) {
	conn, err := sql.Open(dbDriver, dbSource)
	if err != nil{
		log.Fatal("cannot connect to db:", err)
	}

	testQueris = New(conn)

	os.Exit(m.Run())
}
