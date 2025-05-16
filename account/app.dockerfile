# --- Build Stage ---
FROM golang:1.23-alpine AS build

# Install required packages
RUN apk add --no-cache gcc g++ make ca-certificates

# Set working directory
WORKDIR /app

# Copy Go module files and vendor
COPY go.mod go.sum ./
COPY vendor ./vendor

# Copy the account service code
COPY account ./account

# Build the account service binary
RUN CGO_ENABLED=0 GO111MODULE=on go build -mod=vendor -o /bin/app ./account/cmd/account

# --- Runtime Stage ---
FROM alpine:3.18

WORKDIR /usr/bin

# Copy binary from the build stage
COPY --from=build /bin/app .

# Expose service port
EXPOSE 8080

# Start the service
CMD ["./app"]
