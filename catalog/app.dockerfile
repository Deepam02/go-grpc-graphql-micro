# --- Build Stage ---
FROM golang:1.23-alpine AS build

# Install build dependencies
RUN apk add --no-cache gcc g++ make ca-certificates

# Set working directory
WORKDIR /app

# Copy module files and vendor
COPY go.mod go.sum ./
COPY vendor ./vendor

# Copy catalog service source
COPY catalog ./catalog

# Build catalog service binary
RUN CGO_ENABLED=0 GO111MODULE=on go build -mod=vendor -o /bin/app ./catalog/cmd/catalog

# --- Runtime Stage ---
FROM alpine:3.18

WORKDIR /usr/bin

# Copy the compiled binary
COPY --from=build /bin/app .

# Expose application port
EXPOSE 8080

# Start the app
CMD ["./app"]
