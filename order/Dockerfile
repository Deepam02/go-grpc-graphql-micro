FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o order-service ./order

# Use a small alpine image
FROM alpine:latest

WORKDIR /app

# Copy the binary from builder
COPY --from=builder /app/order-service .

# Expose the port
EXPOSE 50052

# Run the service
CMD ["./order-service"] 