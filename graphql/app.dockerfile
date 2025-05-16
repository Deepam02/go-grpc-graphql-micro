# --- Build Stage ---
FROM golang:1.23-alpine AS build

# Install required packages
RUN apk --no-cache add gcc g++ make ca-certificates

# Set working directory
WORKDIR /app

# Copy go.mod, go.sum, and vendor folder
COPY go.mod go.sum ./
COPY vendor ./vendor

# Copy source code directories
COPY account ./account
COPY catalog ./catalog
COPY order ./order
COPY graphql ./graphql

# Build the graphql gateway
RUN CGO_ENABLED=0 GO111MODULE=on go build -mod=vendor -o /bin/app ./graphql

# --- Runtime Stage ---
FROM alpine:3.18

WORKDIR /usr/bin

# Copy the compiled binary
COPY --from=build /bin/app .

# Expose service port
EXPOSE 8080

# Run the service
CMD ["./app"]
