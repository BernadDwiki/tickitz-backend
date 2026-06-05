package router

func InitRoute(router *gin.Engine, db *pgx.Pool) {
	RegisterAuthRouter(router, db)
}