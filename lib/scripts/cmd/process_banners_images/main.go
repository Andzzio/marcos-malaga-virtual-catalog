package main

import (
	"fmt"
	"image"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/disintegration/imaging"
	"github.com/nickalie/go-webpbin"
)

const (
	defaultInputDir  = "../../assets/images/banners"
	fallbackInputDir = "assets/images/banners"
	outputDir        = "./output_processed_banners"
	presetSize       = 800
)

func main() {
	fmt.Println("Iniciando Script: Procesamiento de Imágenes de Banners...")

	// Determinar directorio de entrada
	inputDir := defaultInputDir
	if _, err := os.Stat(inputDir); os.IsNotExist(err) {
		inputDir = fallbackInputDir
	}

	// Crear carpeta de salida si no existe
	if err := os.MkdirAll(outputDir, os.ModePerm); err != nil {
		log.Fatalf("Error creando directorio de salida: %v", err)
	}

	files, err := os.ReadDir(inputDir)
	if err != nil {
		log.Fatalf("Error leyendo directorio de entrada %s: %v", inputDir, err)
	}

	for _, file := range files {
		if file.IsDir() {
			continue
		}

		ext := strings.ToLower(filepath.Ext(file.Name()))
		if ext != ".jpg" && ext != ".jpeg" && ext != ".png" {
			continue
		}

		inputPath := filepath.Join(inputDir, file.Name())
		fmt.Printf("Procesando: %s\n", file.Name())

		// Abrir imagen
		img, err := imaging.Open(inputPath)
		if err != nil {
			log.Printf("Error abriendo %s: %v", file.Name(), err)
			continue
		}

		baseName := strings.TrimSuffix(file.Name(), filepath.Ext(file.Name()))

		// 1. Generar versión con la resolución original completa (sin reducir)
		processAndSave(img, baseName+"_original", 0)

		// 2. Generar versión con medida preestablecida secundaria (800px)
		processAndSave(img, fmt.Sprintf("%s_%d", baseName, presetSize), presetSize)
	}

	fmt.Println("¡Procesamiento de imágenes de banners completado con éxito!")
}

func processAndSave(img image.Image, outputName string, size int) {
	var target image.Image = img
	if size > 0 {
		target = imaging.Fit(img, size, size, imaging.Lanczos)
	}

	outputPath := filepath.Join(outputDir, outputName+".webp")

	// Crear archivo para WebP
	f, err := os.Create(outputPath)
	if err != nil {
		log.Printf("Error creando archivo %s: %v", outputPath, err)
		return
	}
	defer f.Close()

	// Guardar como WebP con calidad 85 usando webpbin
	absPath, _ := filepath.Abs(".")
	cwebp := webpbin.NewCWebP()
	cwebp.Dest(absPath)
	err = cwebp.Quality(85).InputImage(target).Output(f).Run()
	if err != nil {
		log.Printf("Error codificando a WebP %s: %v", outputPath, err)
	} else {
		fmt.Printf(" -> Guardado: %s.webp\n", outputName)
	}
}
