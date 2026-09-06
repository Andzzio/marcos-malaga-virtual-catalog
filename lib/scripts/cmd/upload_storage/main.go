package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"strings"

	firebase "firebase.google.com/go/v4"
	"google.golang.org/api/option"
)

const (
	processedDir   = "./output_processed_images"
	outputMapping  = "url_mapping.json"
	bucketName     = "marcos-malaga-app.firebasestorage.app" // Tu bucket
	credentialsKey = "serviceAccountKey.json"                // Requiere que pongas tu key de Firebase aquí
)

func main() {
	fmt.Println("Iniciando Script 2: Subida a Firebase Storage...")

	ctx := context.Background()
	opt := option.WithCredentialsFile(credentialsKey)
	
	app, err := firebase.NewApp(ctx, &firebase.Config{
		StorageBucket: bucketName,
	}, opt)
	if err != nil {
		log.Fatalf("Error inicializando Firebase: %v\n(Asegúrate de tener el archivo serviceAccountKey.json)", err)
	}

	client, err := app.Storage(ctx)
	if err != nil {
		log.Fatalf("Error obteniendo cliente de Storage: %v", err)
	}

	bucket, err := client.DefaultBucket()
	if err != nil {
		log.Fatalf("Error obteniendo el bucket: %v", err)
	}

	files, err := os.ReadDir(processedDir)
	if err != nil {
		log.Fatalf("Error leyendo el directorio procesado: %v", err)
	}

	urlMap := make(map[string]string)

	for _, file := range files {
		if file.IsDir() || filepath.Ext(file.Name()) != ".webp" {
			continue
		}

		localPath := filepath.Join(processedDir, file.Name())
		remotePath := "products/" + file.Name() // Guardar en la carpeta products/

		fmt.Printf("Subiendo %s...\n", file.Name())
		
		f, err := os.Open(localPath)
		if err != nil {
			log.Printf("Error abriendo %s: %v", localPath, err)
			continue
		}
		defer f.Close()

		obj := bucket.Object(remotePath)
		writer := obj.NewWriter(ctx)
		writer.ContentType = "image/webp"

		if _, err := io.Copy(writer, f); err != nil {
			log.Printf("Error copiando datos a Storage: %v", err)
			continue
		}
		if err := writer.Close(); err != nil {
			log.Printf("Error cerrando writer de Storage: %v", err)
			continue
		}

		// Al hacer el bucket público (como en las reglas que configuraste),
		// la URL pública es predecible:
		publicURL := fmt.Sprintf("https://firebasestorage.googleapis.com/v0/b/%s/o/%s?alt=media", 
			bucketName, 
			strings.ReplaceAll(remotePath, "/", "%2F"),
		)

		// Guardamos en el diccionario. 
		// Ej: "mock_product_800x800.webp" -> "https://..."
		urlMap[file.Name()] = publicURL
		fmt.Printf(" -> Subida exitosa: %s\n", publicURL)
	}

	// Guardar el diccionario en un JSON
	mapData, err := json.MarshalIndent(urlMap, "", "  ")
	if err != nil {
		log.Fatalf("Error formateando el JSON de mapeo: %v", err)
	}

	if err := os.WriteFile(outputMapping, mapData, 0644); err != nil {
		log.Fatalf("Error guardando el archivo de mapeo: %v", err)
	}

	fmt.Printf("¡Subida completada! Mapeo guardado en %s\n", outputMapping)
}
