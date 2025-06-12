FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o catalog-service ./catalog

# Use a small alpine image
FROM alpine:latest

WORKDIR /app

# Copy the binary from builder
COPY --from=builder /app/catalog-service .

# Expose the port
EXPOSE 50053

# Run the service
CMD ["./catalog-service"] 