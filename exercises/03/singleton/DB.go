package singleton

import (
	"database/sql"

	_ "github.com/mattn/go-sqlite3"
)

type Singleton interface {
	Open() string
	Close() string
	SetDBName(name string) string

	GetAllUsers() []string
}

type singleton struct {
	DB *sql.DB 
	name string 
	
}

var instance *singleton


func GetInstance() Singleton {
	if instance == nil {
		instance = new(singleton)
	}
	return instance
}


func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}

func (s *singleton) Open() string {
	var err error

	s.DB, err = sql.Open("sqlite3","./" + s.name)

	checkErr(err)

	stmt , _ := s.DB.Prepare(`
		CREATE TABLE IF NOT EXISTS "users" (
			"id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
			"name" TEXT
		); 
	`)
	
	checkErr(err)

	_ , err = stmt.Exec()

	checkErr(err)
	
	return "Database connection successfuly opened\n"
	
	
}

func (s *singleton) Close() string {
	var err = s.DB.Close()

	checkErr(err)
	
	return "Database connection successfuly closed\n"
}

func (s *singleton) SetDBName(name string) string {
	if(name == ""){
		return "Cannot set an empty name"
	} else {
		s.name = name
		return "Successfully set the db name"
	}
}

func (s *singleton) GetAllUsers() []string {

	users := []string{"user1","user2"}

	return users
}