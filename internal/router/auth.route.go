package router

func RegisterAuthRouter(router *gin.Engine, db *pgx.Pool) {
	authRouter := router.Group("/auth")
}