package main

import (
	"os"
	"os/signal"

	"github.com/gocraft/work"
	"github.com/gomodule/redigo/redis"
)

// 仮実装

var redisPool = &redis.Pool{
	MaxActive: 5,
	MaxIdle:   5,
	Wait:      true,
	Dial: func() (redis.Conn, error) {
		return redis.Dial(
			"tcp",
			"inmemory:6380",
			redis.DialUsername("developer"),
			redis.DialPassword("developer"),
		)
	},
}

type Context struct{}

func main() {
	pool := work.NewWorkerPool(Context{}, 10, "my_app_namespace", redisPool)
	pool.Start()

	signalChan := make(chan os.Signal, 1)
	signal.Notify(signalChan, os.Interrupt, os.Kill)
	<-signalChan

	// Stop the pool
	pool.Stop()
}
