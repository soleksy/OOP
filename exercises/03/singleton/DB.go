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

func (s *singleton) Open() string {
	return ""
}

func (s *singleton) Close() string {
	return ""
}

func (s *singleton) SetDBName(name string) string {
	return ""
}

func (s *singleton) GetAllUsers() []string {

	users := []string{"user1","user2"}

	return users
}