# Gunakan image Go sebagai base image
FROM golang:1.22-alpine AS builder

# Set working directory di dalam kontainer
WORKDIR /app

# Salin file go.mod dan go.sum terlebih dahulu
COPY go.mod go.sum ./

# Download semua dependensi sebelum menyalin source code
RUN go mod tidy && go mod download

# Salin seluruh kode aplikasi Go ke dalam kontainer
COPY . .

# Build aplikasi Go
RUN go build -o main .

# ---- Stage Final ----
FROM alpine:latest  

# Set working directory
WORKDIR /root/

# Copy binary dari stage builder
COPY --from=builder /app/main .

# Expose port 8080
EXPOSE 8080

# Jalankan aplikasi
CMD ["./main"]
