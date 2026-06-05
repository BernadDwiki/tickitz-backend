package main

import (
	_ "github.com/gin-gonic/gin"
	_ "github.com/joho/godotenv"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Printf("Error loading env. \ncause: %s", err.Error())
	}

	app := gin.Default()

	db, err := config.ConnectPsql()
	if err != nil {
		log.Fatalf("DB connection error. \ncause: %s", err.Error())
	}
	defer db.Close()
	log.Println("DB Connected")
	router.InitRouter(app, db, rc)
	app.Run(fmt.Sprintf("%s:%s", os.Getenv("APP_HOST"), os.Getenv("APP_PORT")))

}
