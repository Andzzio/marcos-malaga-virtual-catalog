package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"time"

	"cloud.google.com/go/firestore"
)

const (
	credentialsKey = "serviceAccountKey.json"
	bannersFile    = "banners_cloud.json"
)

func main() {
	fmt.Println("Iniciando Script: Subida de Banners a Firestore...")

	ctx := context.Background()

	// 1. Determinar rutas de credenciales y archivo JSON
	credPath := credentialsKey
	if _, err := os.Stat(credPath); os.IsNotExist(err) {
		credPath = filepath.Join("..", credentialsKey)
		if _, err := os.Stat(credPath); os.IsNotExist(err) {
			credPath = filepath.Join("lib", "scripts", credentialsKey)
		}
	}

	bFile := bannersFile
	if _, err := os.Stat(bFile); os.IsNotExist(err) {
		bFile = filepath.Join("lib", "scripts", bannersFile)
	}

	// Configurar credenciales en el entorno
	os.Setenv("GOOGLE_APPLICATION_CREDENTIALS", credPath)

	// Inicializar cliente de Firestore en la base de datos 'default'
	client, err := firestore.NewClientWithDatabase(ctx, "marcos-malaga-app", "default")
	if err != nil {
		log.Fatalf("❌ Error obteniendo cliente de Firestore: %v", err)
	}
	defer client.Close()

	// 2. Leer banners_cloud.json
	file, err := os.Open(bFile)
	if err != nil {
		log.Fatalf("❌ Error abriendo %s: %v", bFile, err)
	}
	defer file.Close()

	byteValue, err := io.ReadAll(file)
	if err != nil {
		log.Fatalf("❌ Error leyendo %s: %v", bFile, err)
	}

	var banners []map[string]interface{}
	if err := json.Unmarshal(byteValue, &banners); err != nil {
		log.Fatalf("❌ Error decodificando JSON: %v", err)
	}

	fmt.Printf("📦 Procesando %d banners (Modo Síncrono Seguro)...\n", len(banners))
	validBanners := 0

	// 3. Iterar, extraer 'id', parsear 'createdAt' y subir a Firestore
	for _, banner := range banners {
		idVal, ok := banner["id"]
		if !ok {
			log.Printf("⚠️ Advertencia: banner ignorado por no tener campo 'id': %v", banner)
			continue
		}

		idStr, ok := idVal.(string)
		if !ok {
			log.Printf("⚠️ Advertencia: el campo 'id' no es un string: %v", idVal)
			continue
		}

		// Extraer "createdAt" y parsearlo a time.Time de Go (Timestamp nativo de Firestore)
		createdAtVal, ok := banner["createdAt"]
		if ok {
			createdAtStr, ok := createdAtVal.(string)
			if ok {
				parsedTime, err := time.Parse(time.RFC3339, createdAtStr)
				if err != nil {
					log.Printf("⚠️ Error al parsear createdAt '%s' para el banner '%s': %v", createdAtStr, idStr, err)
				} else {
					banner["createdAt"] = parsedTime
				}
			}
		}

		// Subir a la colección 'banners' de Firestore
		docRef := client.Collection("banners").Doc(idStr)
		_, err := docRef.Set(ctx, banner)
		if err != nil {
			log.Fatalf("\n❌ Error CRÍTICO al subir banner %s: %v", idStr, err)
		}

		fmt.Printf(" ✔️ Subido exitosamente a colección 'banners': %s\n", idStr)
		validBanners++
	}

	fmt.Printf("\n✅ ¡Subida a Firestore completada exitosamente! (%d banners en colección 'banners')\n", validBanners)
}
