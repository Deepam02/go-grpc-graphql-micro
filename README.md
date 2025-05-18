# Go gRPC GraphQL Microservices

A modern microservices architecture built with Go, gRPC, and GraphQL, featuring multiple services for account management, catalog, and order processing. This project demonstrates a complete e-commerce system with separate microservices for user accounts, product catalog, and order management, all unified through a GraphQL API gateway.

## Architecture Overview

This project implements a microservices architecture with the following components:

### Account Service
- Handles user account management and authentication
- Uses PostgreSQL for data storage
- Provides gRPC endpoints for:
  - Creating new accounts
  - Retrieving individual accounts
  - Listing accounts with pagination
- Implements repository pattern for database operations

### Catalog Service
- Manages product catalog with Elasticsearch integration
- Provides gRPC endpoints for:
  - Adding new products
  - Retrieving individual products
  - Searching products with pagination and filtering
  - Full-text search capabilities
- Uses Elasticsearch for efficient product search and storage

### Order Service
- Processes and manages orders
- Uses PostgreSQL for order data storage
- Provides gRPC endpoints for:
  - Creating new orders
  - Retrieving orders for specific accounts
- Integrates with Account and Catalog services
- Implements complex order processing logic

### GraphQL Gateway
- Provides a unified GraphQL API
- Exposes the following operations:
  - Mutations:
    - createAccount
    - createProduct
    - createOrder
  - Queries:
    - accounts (with pagination)
    - products (with search and pagination)
- Aggregates data from all microservices
- Implements resolvers for each service

## Technology Stack

- **Language**: Go 1.24
- **Communication**: gRPC for inter-service communication
- **API Gateway**: GraphQL (gqlgen)
- **Databases**:
  - PostgreSQL for Account and Order services
  - Elasticsearch 6.2.4 for Catalog service
- **Containerization**: Docker and Docker Compose
- **Protocol Buffers**: For service definitions
- **Dependencies**:
  - github.com/99designs/gqlgen
  - google.golang.org/grpc
  - github.com/lib/pq
  - gopkg.in/olivere/elastic.v5

## Project Structure

```
.
├── account/                 # Account service
│   ├── cmd/                # Service entry point
│   ├── pb/                 # Generated protobuf files
│   ├── account.proto       # Service definition
│   ├── repository.go       # Database operations
│   ├── service.go          # Business logic
│   └── server.go           # gRPC server implementation
├── catalog/                # Catalog service
│   ├── cmd/                # Service entry point
│   ├── pb/                 # Generated protobuf files
│   ├── catalog.proto       # Service definition
│   ├── repository.go       # Elasticsearch operations
│   ├── service.go          # Business logic
│   └── server.go           # gRPC server implementation
├── order/                  # Order service
│   ├── cmd/                # Service entry point
│   ├── pb/                 # Generated protobuf files
│   ├── order.proto         # Service definition
│   ├── repository.go       # Database operations
│   ├── service.go          # Business logic
│   └── server.go           # gRPC server implementation
├── graphql/                # GraphQL gateway
│   ├── schema.graphql      # GraphQL schema definition
│   ├── generated.go        # Generated GraphQL code
│   ├── resolvers/          # GraphQL resolvers
│   └── server.go           # GraphQL server implementation
├── docker-compose.yaml     # Service orchestration
└── go.mod                  # Go module definition
```

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/deepam02/go-grpc-graphql-micro.git
   cd go-grpc-graphql-micro
   ```

2. Install dependencies:
   ```bash
   go mod download
   ```

3. Start the services using Docker Compose:
   ```bash
   docker-compose up -d
   ```

4. The GraphQL API will be available at:
   ```
   http://localhost:8000
   ```

## API Documentation

### GraphQL API

#### Mutations
```graphql
# Create a new account
mutation {
  createAccount(account: { name: "John Doe" }) {
    id
    name
  }
}

# Create a new product
mutation {
  createProduct(product: {
    name: "Product Name"
    description: "Product Description"
    price: 99.99
  }) {
    id
    name
    price
  }
}

# Create a new order
mutation {
  createOrder(order: {
    accountId: "account-id"
    products: [
      { id: "product-id", quantity: 2 }
    ]
  }) {
    id
    totalPrice
  }
}
```

#### Queries
```graphql
# Get accounts with pagination
query {
  accounts(pagination: { skip: 0, take: 10 }) {
    id
    name
    orders {
      id
      totalPrice
    }
  }
}

# Search products
query {
  products(pagination: { skip: 0, take: 10 }, query: "search term") {
    id
    name
    description
    price
  }
}
```

## Environment Variables

Each service can be configured using environment variables:

- `DATABASE_URL`: Database connection string
- `ACCOUNT_SERVICE_URL`: URL for Account service (default: account:8080)
- `CATALOG_SERVICE_URL`: URL for Catalog service (default: catalog:8080)
- `ORDER_SERVICE_URL`: URL for Order service (default: order:8080)

## Development

1. Generate protobuf files:
   ```bash
   protoc --go_out=. --go_opt=paths=source_relative \
          --go-grpc_out=. --go-grpc_opt=paths=source_relative \
          */pb/*.proto
   ```

2. Generate GraphQL code:
   ```bash
   cd graphql
   go run github.com/99designs/gqlgen generate
   ```

3. Run tests:
   ```bash
   go test ./...
   ```

4. Build services:
   ```bash
   go build ./...
   ```

## Docker Support

The project includes Docker configurations for all services:

- Each service has its own Dockerfile
- Docker Compose orchestrates all services
- Database services are included in the Docker Compose configuration
- Health checks are implemented for critical services

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [gRPC](https://grpc.io/)
- [GraphQL](https://graphql.org/)
- [gqlgen](https://github.com/99designs/gqlgen)
- [Elasticsearch](https://www.elastic.co/)
- [PostgreSQL](https://www.postgresql.org/) 