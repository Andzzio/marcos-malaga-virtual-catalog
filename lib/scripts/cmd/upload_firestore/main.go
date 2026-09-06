package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"os"
	"time"

	"cloud.google.com/go/firestore"
)

const (
	credentialsKey = "serviceAccountKey.json"
	productsFile   = "products_cloud.json"
)

func main() {
	fmt.Println("Iniciando Script: Subida a Firestore...")

	ctx := context.Background()

	// 1. Inicializar Firestore directamente bypasseando a Firebase (Para forzar el ID de base de datos)
	os.Setenv("GOOGLE_APPLICATION_CREDENTIALS", credentialsKey)
	
	client, err := firestore.NewClientWithDatabase(ctx, "marcos-malaga-app", "default")
	if err != nil {
		log.Fatalf("❌ Error obteniendo cliente de Firestore: %v", err)
	}
	defer client.Close()

	// 2. Leer products_cloud.json
	file, err := os.Open(productsFile)
	if err != nil {
		log.Fatalf("❌ Error abriendo %s: %v", productsFile, err)
	}
	defer file.Close()

	byteValue, err := io.ReadAll(file)
	if err != nil {
		log.Fatalf("❌ Error leyendo %s: %v", productsFile, err)
	}

	var products []map[string]interface{}
	if err := json.Unmarshal(byteValue, &products); err != nil {
		log.Fatalf("❌ Error decodificando JSON: %v", err)
	}

	fmt.Printf("📦 Procesando %d productos (Modo Síncrono Seguro)...\n", len(products))
	validProducts := 0

	// 4 & 5. Iterar, extraer 'id' y parsear 'createdAt'
	for _, product := range products {
		idVal, ok := product["id"]
		if !ok {
			log.Printf("⚠️ Advertencia: producto ignorado por no tener campo 'id': %v", product)
			continue
		}

		idStr, ok := idVal.(string)
		if !ok {
			log.Printf("⚠️ Advertencia: el campo 'id' no es un string: %v", idVal)
			continue
		}

		// Extraer "createdAt" y parsearlo a time.Time de Go
		createdAtVal, ok := product["createdAt"]
		if ok {
			createdAtStr, ok := createdAtVal.(string)
			if ok {
				parsedTime, err := time.Parse(time.RFC3339, createdAtStr)
				if err != nil {
					log.Printf("⚠️ Error al parsear createdAt '%s' para el producto '%s': %v", createdAtStr, idStr, err)
				} else {
					product["createdAt"] = parsedTime // Reemplazar con el objeto nativo Timestamp
				}
			}
		}

		// 6. Subir de forma síncrona
		docRef := client.Collection("products").Doc(idStr)
		_, err := docRef.Set(ctx, product)
		if err != nil {
			log.Fatalf("\n❌ Error CRÍTICO al subir producto %s: %v", idStr, err)
		}

		fmt.Printf(" ✔️ Subido exitosamente: %s\n", idStr)
		validProducts++
	}

	fmt.Printf("\n✅ ¡Subida a Firestore completada exitosamente! (%d productos)\n", validProducts)
}
