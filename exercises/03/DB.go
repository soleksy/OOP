package singleton

import (
  _ "github.com/mattn/go-sqlite3"
	"log"
)


type Singleton interface {
	str string
   }

type interf interface{
	get_string() string
}

func (t A) get_string() string {
	return t.str
}

func main(){
	var struct_intr interf
	st := A{"123"}
	struct_intr=st
	log.Println(struct_intr.get_string())
}