# --- Build Stage ---
FROM golang:1.23-alpine AS build

RUN apk add --no-cache gcc g++ make ca-certificates

WORKDIR /app

# Copy Go module files first to leverage caching
COPY go.mod go.sum ./
COPY vendor ./vendor

# Copy only catalog service
COPY ./catalog ./catalog

RUN CGO_ENABLED=0 GO111MODULE=on go build -mod=vendor -o /bin/app ./catalog/cmd/catalog

# --- Runtime Stage ---
FROM alpine:3.18

WORKDIR /usr/bin

COPY --from=build /bin/app .

EXPOSE 8080

CMD ["./app"]
