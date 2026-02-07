package main

import cron "github.com/netresearch/go-cron"

func main() {
	c := cron.New()

	c.Start()

	select {}
}
