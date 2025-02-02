# Gunakan image Go sebagai base image
FROM golang:1.20-alpine

# Set working directory di dalam kontainer
WORKDIR /app

# Salin go.mod dan go.sum terlebih dahulu untuk memanfaatkan caching dependencies
COPY go.mod go.sum ./
RUN go mod download

# Salin seluruh kode aplikasi Go ke dalam kontainer
COPY . .

# Build aplikasi Go
RUN go build -o main .

# Expose port 8080
EXPOSE 8080

# Jalankan aplikasi Go
CMD ["./main"]
