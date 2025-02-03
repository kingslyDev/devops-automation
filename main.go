package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "Halo Dunia DevOps terus ngaji")
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("Server running on port 8080...")

    err := http.ListenAndServe(":8080", nil)
    if err != nil {
        fmt.Println("Error starting server:", err)
    }
}
