package main

import (
	"github.com/labstack/echo/v5"
)

func main() {
	e := echo.New()

	e.GET("/api/v1/health", func(c *echo.Context) error {
		return c.String(200, "OK")
	})

	if err := e.Start(":8080"); err != nil {
		e.Logger.Error("failed to start server", "error", err)
	}
}
