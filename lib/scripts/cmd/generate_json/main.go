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
	productsFile := "assets/json/products.json"
	urlMappingFile := "lib/scripts/url_mapping.json"
	outputFile := "lib/scripts/products_cloud.json"

	// Read products
	pData, err := os.ReadFile(productsFile)
	if err != nil {
		log.Fatalf("Error reading products.json: %v", err)
	}
	var products []map[string]interface{}
	if err := json.Unmarshal(pData, &products); err != nil {
		log.Fatalf("Error unmarshalling products: %v", err)
	}

	// Read url mapping
	uData, err := os.ReadFile(urlMappingFile)
	if err != nil {
		log.Fatalf("Error reading url_mapping.json: %v", err)
	}
	var urlMapping map[string]string
	if err := json.Unmarshal(uData, &urlMapping); err != nil {
		log.Fatalf("Error unmarshalling url mapping: %v", err)
	}

	now := time.Now().Format(time.RFC3339)

	for i := range products {
		products[i]["createdAt"] = now

		designsRaw, ok := products[i]["designs"].([]interface{})
		if !ok {
			continue
		}
		for j := range designsRaw {
			design, ok := designsRaw[j].(map[string]interface{})
			if !ok {
				continue
			}

			imageUrlsRaw, ok := design["imageUrls"].([]interface{})
			if !ok {
				continue
			}

			for k := range imageUrlsRaw {
				imgUrl, ok := imageUrlsRaw[k].(string)
				if !ok {
					continue
				}

				// Extract the base name without extension
				base := filepath.Base(imgUrl)
				ext := filepath.Ext(base)
				nameWithoutExt := strings.TrimSuffix(base, ext)

				key := fmt.Sprintf("%s_800x800.webp", nameWithoutExt)

				if cloudUrl, exists := urlMapping[key]; exists {
					imageUrlsRaw[k] = cloudUrl
				}
			}
			design["imageUrls"] = imageUrlsRaw
		}
	}

	outData, err := json.MarshalIndent(products, "", "  ")
	if err != nil {
		log.Fatalf("Error marshaling output: %v", err)
	}

	// Ensure the output directory exists
	outDir := filepath.Dir(outputFile)
	if err := os.MkdirAll(outDir, 0755); err != nil {
		log.Fatalf("Error creating output directory: %v", err)
	}

	if err := os.WriteFile(outputFile, outData, 0644); err != nil {
		log.Fatalf("Error writing output file: %v", err)
	}

	fmt.Println("Successfully generated", outputFile)
}
