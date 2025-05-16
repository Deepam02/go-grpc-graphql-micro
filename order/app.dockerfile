# --- Build Stage ---
FROM golang:1.23-alpine AS build

# Install build dependencies
RUN apk --no-cache add gcc g++ make ca-certificates

# Set working directory
WORKDIR /app

# Copy go mod and vendor
COPY go.mod go.sum ./
COPY vendor ./vendor

# Copy source code
COPY account ./account
COPY catalog ./catalog
COPY order ./order

# Build the order service binary
RUN CGO_ENABLED=0 GO111MODULE=on go build -mod=vendor -o /bin/app ./order/cmd/order

# --- Runtime Stage ---
FROM alpine:3.18

WORKDIR /usr/bin

# Copy binary from builder
COPY --from=build /bin/app .

# Expose application port
EXPOSE 8080

# Run the service
CMD ["./app"]
