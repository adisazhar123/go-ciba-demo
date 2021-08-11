package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"

	firebase "firebase.google.com/go/v4"
	gociba "github.com/adisazhar123/go-ciba"
	"github.com/adisazhar123/go-ciba/grant"
	gocibaRepo "github.com/adisazhar123/go-ciba/repository"
	gocibaService "github.com/adisazhar123/go-ciba/service"
	gocibaTransport "github.com/adisazhar123/go-ciba/service/transport"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
)

var (
	host     = os.Getenv("DB_HOST")
	port, _     = strconv.ParseInt(os.Getenv("DB_PORT"), 10, 64)
	user     = os.Getenv("DB_USER")
	password = os.Getenv("DB_PASSWORD")
	dbname   = os.Getenv("DB_SCHEMA")
	fcmServerKey = os.Getenv("FCM_SERVER_KEY")
)

var pollIntervalInSeconds int64 = 5

func cors() gin.HandlerFunc {
	return func(c *gin.Context) {

		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Credentials", "true")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Header("Access-Control-Allow-Methods", "POST,HEAD,PATCH, OPTIONS, GET, PUT")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}
func main() {
	r := gin.New()

	r.Use(gin.Logger())
	r.Use(cors())


	dsn := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)
	fmt.Println(dsn)
	db, err := sql.Open("postgres", dsn)

	if err != nil {
		log.Fatal("db err", err)
	}

	dataStore := gocibaRepo.NewSQLDataStore(db, "postgres", "")

	cibaGrant := grant.NewCustomCibaGrant(&grant.GrantConfig{
		Issuer:                       "auth.ciba.com",
		IdTokenLifetimeInSeconds:     3600,
		AccessTokenLifetimeInSeconds: 3600,
		PollingIntervalInSeconds:     &pollIntervalInSeconds,
		AuthReqIdLifetimeInSeconds:   120,
		TokenEndpointUrl:             "/token",
	})

	fmt.Println("fcmServerKey", fcmServerKey)

	cibaService := gocibaService.NewCibaService(
		dataStore.GetClientApplicationRepository(),
		dataStore.GetUserAccountRepository(),
		dataStore.GetCibaSessionRepository(),
		dataStore.GetKeyRepository(),
		dataStore.GetUserClaimRepository(),
		gocibaTransport.NewFirebaseCloudMessaging(fcmServerKey),
		cibaGrant,
		func(token string) bool {
			return token != ""
		},
	)

	tokenService := gocibaService.NewTokenService(
		dataStore.GetAccessTokenRepository(),
		dataStore.GetClientApplicationRepository(),
		dataStore.GetCibaSessionRepository(),
		dataStore.GetKeyRepository(),
		dataStore.GetUserClaimRepository(),
		cibaGrant,
	)

	authorizationServer := gociba.NewAuthorizationServer(dataStore)
	authorizationServer.AddService(cibaService)

	tokenServer := gociba.NewTokenServer(tokenService)

	resourceServer := gociba.NewResourceServer(dataStore.GetAccessTokenRepository())

	app, err := firebase.NewApp(context.Background(), nil)
	if err != nil {
		log.Fatalf("error initializing firebase app: %v\n", err)
	}

	messaging , err := app.Messaging(context.Background())

	if err != nil {
		log.Fatalf("error initializing firebase messaging: %v\n", err)
	}

	r.GET("/", func(context *gin.Context) {
		context.JSON(http.StatusOK, "ok")
	})

	r.POST("/subscribe", func(c *gin.Context) {
		token := c.PostForm("token")
		userId := c.PostForm("user_id")
		topic := fmt.Sprintf("ciba_consent_%s", userId)
		res, err := messaging.SubscribeToTopic(context.Background(), []string{token}, topic)
		if err != nil {
			c.JSON(http.StatusInternalServerError, err)
			return
		}
		c.JSON(http.StatusOK, res)
	})

	r.POST("/auth", func(context *gin.Context) {
		req := gocibaService.NewAuthenticationRequest(context.Request)
		req.ValidateBindingMessage = func(bindingMessage string) bool {
			return true
		}
		req.ValidateUserCode = func(code, givenCode string) bool {
			return true
		}
		res, err := authorizationServer.HandleCibaRequest(req)
		if err != nil {
			context.JSON(err.Code, err)
			return
		}
		context.JSON(http.StatusOK, res)
	})

	r.POST("/consent", func(context *gin.Context) {
		authReqId := context.PostForm("auth_req_id")
		consented := context.PostForm("consented") == "true"
		req := gocibaService.NewConsentRequest(authReqId, &consented)

		err := authorizationServer.HandleConsentRequest(req)
		if err != nil {
			context.JSON(err.Code, err)
			return
		}
		context.JSON(http.StatusOK, req)
	})

	r.POST("/token", func(context *gin.Context) {
		req := gocibaService.NewTokenRequest(context.Request)
		res, err := tokenServer.HandleTokenRequest(req)
		if err != nil {
			context.JSON(err.Code, err)
			return
		}
		context.JSON(http.StatusOK, res)
	})

	r.POST("/protected", func(c *gin.Context) {
		req := gociba.NewResourceRequest(c.Request)
		err := resourceServer.HandleResourceRequest(req, "timestamp.read")
		if err != nil {
			c.JSON(err.Code, err)
			return
		}
		c.JSON(http.StatusOK, "In protected resource")
	})

	if err := http.ListenAndServe(":20000", r); err != nil {
		log.Fatalln("listen and server err", err)
	}
}
