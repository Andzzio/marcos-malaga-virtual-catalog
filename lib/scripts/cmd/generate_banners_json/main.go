package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
	"time"
)

func main() {
	bannersFile := "assets/json/banners.json"
	if _, err := os.Stat(bannersFile); os.IsNotExist(err) {
		bannersFile = "../../assets/json/banners.json"
	}

	urlMappingFile := "banners_url_mapping.json"
	if _, err := os.Stat(urlMappingFile); os.IsNotExist(err) {
		urlMappingFile = "lib/scripts/banners_url_mapping.json"
	}

	outputFile := "banners_cloud.json"
	if _, err := os.Stat("lib/scripts"); err == nil {
		outputFile = "lib/scripts/banners_cloud.json"
	}

	// 1. Leer banners.json original
	bData, err := os.ReadFile(bannersFile)
	if err != nil {
		log.Fatalf("Error leyendo %s: %v", bannersFile, err)
	}
	var banners []map[string]interface{}
	if err := json.Unmarshal(bData, &banners); err != nil {
		log.Fatalf("Error deserializando banners: %v", err)
	}

	// 2. Leer banners_url_mapping.json si existe o usar URLs predecibles
	var urlMapping = make(map[string]string)
	uData, err := os.ReadFile(urlMappingFile)
	if err == nil {
		if err := json.Unmarshal(uData, &urlMapping); err != nil {
			log.Printf("Advertencia deserializando mapeo de URLs: %v", err)
		}
	} else {
		fmt.Println("Aviso: No se encontró banners_url_mapping.json, generando URLs predecibles de Firebase Storage...")
	}

	now := time.Now().Format(time.RFC3339)

	for i := range banners {
		banners[i]["index"] = i
		banners[i]["createdAt"] = now

		// Mapear medio Desktop a URL en la nube (usando la resolución original .webp)
		desktopPath, ok := banners[i]["desktopImageUrl"].(string)
		if !ok || desktopPath == "" {
			desktopPath, _ = banners[i]["desktopUrl"].(string)
		}
		if desktopPath != "" {
			base := filepath.Base(desktopPath)
			ext := filepath.Ext(base)
			nameWithoutExt := strings.TrimSuffix(base, ext)
			key := fmt.Sprintf("%s_original.webp", nameWithoutExt)

			cloudUrl, exists := urlMapping[key]
			if !exists {
				cloudUrl = fmt.Sprintf("https://firebasestorage.googleapis.com/v0/b/marcos-malaga-app.firebasestorage.app/o/banners%%2F%s?alt=media", key)
			}
			banners[i]["desktopUrl"] = cloudUrl
			banners[i]["desktopMediaType"] = "image"
			delete(banners[i], "desktopImageUrl")
		}

		// Mapear medio Mobile a URL en la nube (usando la resolución original .webp)
		mobilePath, ok := banners[i]["mobileImageUrl"].(string)
		if !ok || mobilePath == "" {
			mobilePath, _ = banners[i]["mobileUrl"].(string)
		}
		if mobilePath != "" {
			base := filepath.Base(mobilePath)
			ext := filepath.Ext(base)
			nameWithoutExt := strings.TrimSuffix(base, ext)
			key := fmt.Sprintf("%s_original.webp", nameWithoutExt)

			cloudUrl, exists := urlMapping[key]
			if !exists {
				cloudUrl = fmt.Sprintf("https://firebasestorage.googleapis.com/v0/b/marcos-malaga-app.firebasestorage.app/o/banners%%2F%s?alt=media", key)
			}
			banners[i]["mobileUrl"] = cloudUrl
			banners[i]["mobileMediaType"] = "image"
			delete(banners[i], "mobileImageUrl")
		}
	}

	outData, err := json.MarshalIndent(banners, "", "  ")
	if err != nil {
		log.Fatalf("Error serializando JSON de salida: %v", err)
	}

	// Asegurar que el directorio de salida existe
	outDir := filepath.Dir(outputFile)
	if outDir != "." && outDir != "" {
		if err := os.MkdirAll(outDir, 0755); err != nil {
			log.Fatalf("Error creando directorio de salida: %v", err)
		}
	}

	if err := os.WriteFile(outputFile, outData, 0644); err != nil {
		log.Fatalf("Error escribiendo archivo %s: %v", outputFile, err)
	}

	fmt.Println("¡Archivo generado exitosamente:", outputFile)
}
