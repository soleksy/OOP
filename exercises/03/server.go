package main

import (
	"net/http"

	"03/singleton"

	"github.com/labstack/echo/v4"
	_ "github.com/mattn/go-sqlite3"
)

func main() {

	DB := singleton.GetInstance()

	DB.SetDBName("users.db")

	DB.Open()

	
	//DB.UpdateUser(4,"Vladimir")
	//DB.DeleteUser(1)
	//DB.DeleteUser(2)
	//DB.DeleteUser(3)

	DB.AddUser("Jacek")

	e := echo.New()

	e.GET("/users", func(c echo.Context) error {
		users := DB.GetAllUsers()

		if err := c.Bind(users); err != nil{
			return err
		}
		return c.JSON(http.StatusCreated, users)
	})

	e.Logger.Fatal(e.Start(":1323"))
}
