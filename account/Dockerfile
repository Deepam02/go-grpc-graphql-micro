FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o account-service ./account

# Use a small alpine image
FROM alpine:latest

WORKDIR /app

# Copy the binary from builder
COPY --from=builder /app/account-service .

# Expose the port
EXPOSE 50051

# Run the service
CMD ["./account-service"] 