# Go gRPC GraphQL Microservices

A modern microservices architecture built with Go, gRPC, and GraphQL, featuring multiple services for account management, catalog, and order processing. This project demonstrates a complete e-commerce system with separate microservices for user accounts, product catalog, and order management, all unified through a GraphQL API gateway.

## Features

- **Microservices Architecture**
  - Account Service (User Management)
  - Catalog Service (Product Management)
  - Order Service (Order Processing)
  - GraphQL Gateway (Unified API)

- **Technology Stack**
  - **Backend**: Go
  - **Communication**: gRPC
  - **API Gateway**: GraphQL (gqlgen)
  - **Databases**: 
    - PostgreSQL (Account & Order services)
    - Elasticsearch 6.2.4 (Catalog service)
  - **Containerization**: Docker & Docker Compose

## Prerequisites

- Go 1.24 or later
- Docker and Docker Compose
- Protocol Buffers compiler (protoc)
- Make (optional, for using Makefile commands)

## Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/deepam02/go-grpc-graphql-micro.git
   cd go-grpc-graphql-micro
   ```

2. **Start the services**
   ```bash
   docker-compose up --build
   ```

3. **Access the GraphQL Playground**
   ```
   http://localhost:8000/playground
   ```

## Service Details

### Account Service
- **Port**: 8080 (internal)
- **Database**: PostgreSQL
- **Features**:
  - Account creation
  - Account retrieval
  - Account listing with pagination

### Catalog Service
- **Port**: 8080 (internal)
- **Database**: Elasticsearch 6.2.4
- **Features**:
  - Product creation
  - Product search
  - Product listing with pagination

### Order Service
- **Port**: 8080 (internal)
- **Database**: PostgreSQL
- **Features**:
  - Order creation
  - Order retrieval
  - Integration with Account and Catalog services

### GraphQL Gateway
- **Port**: 8000 (external)
- **Features**:
  - Unified GraphQL API
  - GraphQL Playground
  - Health check endpoint

## API Documentation

### GraphQL API

#### Mutations

1. **Create Account**
   ```graphql
   mutation {
     createAccount(account: { name: "John Doe" }) {
       id
       name
     }
   }
   ```

2. **Create Product**
   ```graphql
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
   ```

3. **Create Order**
   ```graphql
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

1. **Get Accounts**
   ```graphql
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
   ```

2. **Search Products**
   ```graphql
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

### Account Service
- `DATABASE_URL`: PostgreSQL connection string

### Catalog Service
- `DATABASE_URL`: Elasticsearch connection string

### Order Service
- `DATABASE_URL`: PostgreSQL connection string
- `ACCOUNT_SERVICE_URL`: Account service URL
- `CATALOG_SERVICE_URL`: Catalog service URL

### GraphQL Service
- `ACCOUNT_SERVICE_URL`: Account service URL
- `CATALOG_SERVICE_URL`: Catalog service URL
- `ORDER_SERVICE_URL`: Order service URL

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
