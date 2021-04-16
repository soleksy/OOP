package singleton

import (
	"database/sql"

	_ "github.com/mattn/go-sqlite3"
)

type Item struct {
	Name string `json:"name"`
	ID int `json:"id"`
}

type Singleton interface {
	Open() string
	Close() string
	SetDBName(name string) string

	AddUser(name string) string
	DeleteUser(id int) string
	UpdateUser(id int , name string) string
	GetUser(id int) string

	GetAllUsers() []Item

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

func (s *singleton) GetAllUsers() []Item  {
	items := [] Item{}
	rows , err := s.DB.Query("SELECT * FROM users")

	checkErr(err)

	defer rows.Close()
	var id int
	var name string

	for rows.Next() {
		rows.Scan(&id, &name)
		items = append(items, Item{name,id})
	}

	return items
}

func (s *singleton) AddUser(name string) string {
	stmt , err := s.DB.Prepare(`INSERT INTO users (name) values (?)`)

	checkErr(err)
	
	_ , err = stmt.Exec(name)

	checkErr(err)
	return "User added"

}

func (s *singleton) GetUser(id int) string {

	user , err := s.DB.Query("SELECT name FROM users WHERE id = ?" , id)

	checkErr(err)
		
	defer user.Close()
	var name string
	
	for user.Next(){
		user.Scan(&name)
	}

	return name

}

func (s *singleton) UpdateUser(id int , name string) string {
	stmt, err := s.DB.Prepare("UPDATE users SET name=? WHERE id=?")
	
	checkErr(err)

	_ , err = stmt.Exec(name , id)

	checkErr(err)

	return "User information updated"

}

func (s *singleton) DeleteUser(id int) string {
	stmt, err := s.DB.Prepare("DELETE FROM users WHERE id=?")
	
	checkErr(err)

	_ , err = stmt.Exec(id)

	checkErr(err)

	return "User deleted"
}