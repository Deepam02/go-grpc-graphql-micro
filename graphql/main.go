package main

import (
	"log"
	"net/http"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/kelseyhightower/envconfig"
)

type AppConfig struct {
	AccountUrl string `envconfig:"ACCOUNT_SERVICE_URL"`
	CatalogUrl string `envconfig:"CATALOG_SERVICE_URL"`
	OrderUrl   string `envconfig:"ORDER_SERVICE_URL"`
}

func main() {
	var cfg AppConfig
	err := envconfig.Process("", &cfg)
	if err != nil {
		log.Fatal(err)
	}

	log.Printf("Starting GraphQL server with config: Account=%s, Catalog=%s, Order=%s", 
		cfg.AccountUrl, cfg.CatalogUrl, cfg.OrderUrl)

	s, err := NewGraphQLServer(cfg.AccountUrl, cfg.CatalogUrl, cfg.OrderUrl)
	if err != nil {
		log.Printf("Failed to create GraphQL server: %v", err)
		log.Fatal(err)
	}

	// Use NewDefaultServer to support all transports (POST, GET, multipart, websocket, etc.)
	h := handler.NewDefaultServer(s.ToExecutableSchema())

	// Add middleware for logging
	http.Handle("/graphql", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Received request: %s %s", r.Method, r.URL.Path)
		h.ServeHTTP(w, r)
	}))

	// Add playground
	http.Handle("/playground", playground.Handler("GraphQL Playground", "/graphql"))

	// Add health check endpoint
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	})

	log.Printf("GraphQL server starting on :8080")
	log.Printf("Playground available at /playground")
	log.Printf("GraphQL endpoint available at /graphql")

	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Printf("Server failed to start: %v", err)
		log.Fatal(err)
	}
}
