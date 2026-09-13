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
	processedDir   = "./output_processed_banners"
	outputMapping  = "banners_url_mapping.json"
	bucketName     = "marcos-malaga-app.firebasestorage.app"
	credentialsKey = "serviceAccountKey.json"
)

func main() {
	fmt.Println("Iniciando Script: Subida de Banners a Firebase Storage...")

	// Validar que exista el archivo de credenciales
	credPath := credentialsKey
	if _, err := os.Stat(credPath); os.IsNotExist(err) {
		credPath = filepath.Join("..", credentialsKey)
		if _, err := os.Stat(credPath); os.IsNotExist(err) {
			credPath = filepath.Join("lib", "scripts", credentialsKey)
		}
	}

	ctx := context.Background()
	opt := option.WithCredentialsFile(credPath)

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
		log.Fatalf("Error leyendo el directorio procesado %s: %v", processedDir, err)
	}

	urlMap := make(map[string]string)

	for _, file := range files {
		ext := strings.ToLower(filepath.Ext(file.Name()))
		if file.IsDir() || (ext != ".webp" && ext != ".mp4") {
			continue
		}

		localPath := filepath.Join(processedDir, file.Name())
		remotePath := "banners/" + file.Name() // Guardar en la carpeta banners/ de Firebase Storage

		fmt.Printf("Subiendo %s...\n", file.Name())

		f, err := os.Open(localPath)
		if err != nil {
			log.Printf("Error abriendo %s: %v", localPath, err)
			continue
		}

		contentType := "image/webp"
		if ext == ".mp4" {
			contentType = "video/mp4"
		}

		obj := bucket.Object(remotePath)
		writer := obj.NewWriter(ctx)
		writer.ContentType = contentType

		if _, err := io.Copy(writer, f); err != nil {
			f.Close()
			log.Printf("Error copiando datos a Storage: %v", err)
			continue
		}
		f.Close()
		if err := writer.Close(); err != nil {
			log.Printf("Error cerrando writer de Storage: %v", err)
			continue
		}

		// URL pública de descarga con formato de Firebase Storage
		publicURL := fmt.Sprintf("https://firebasestorage.googleapis.com/v0/b/%s/o/%s?alt=media",
			bucketName,
			strings.ReplaceAll(remotePath, "/", "%2F"),
		)

		urlMap[file.Name()] = publicURL
		fmt.Printf(" -> Subida exitosa: %s\n", publicURL)
	}

	// Guardar el diccionario en un JSON
	mapData, err := json.MarshalIndent(urlMap, "", "  ")
	if err != nil {
		log.Fatalf("Error formateando el JSON de mapeo: %v", err)
	}

	if err := os.WriteFile(outputMapping, mapData, 0644); err != nil {
		log.Fatalf("Error guardando el archivo de mapeo %s: %v", outputMapping, err)
	}

	fmt.Printf("¡Subida completada! Mapeo guardado en %s\n", outputMapping)
}
