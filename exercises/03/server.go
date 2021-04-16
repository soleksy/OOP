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

	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, World!")
	})
	e.Logger.Fatal(e.Start(":1323"))
}
