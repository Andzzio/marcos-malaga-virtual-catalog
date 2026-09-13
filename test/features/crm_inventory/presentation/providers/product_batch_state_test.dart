import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/product_batch_state.dart';

void main() {
  group('BatchImageItem', () {
    test('network image properties', () {
      const item = BatchImageItem.network('https://example.com/photo.jpg');
      expect(item.isNetwork, isTrue);
      expect(item.isMemory, isFalse);
      expect(item.url, 'https://example.com/photo.jpg');
      expect(item.bytes, isNull);
    });

    test('memory image properties', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4]);
      final item = BatchImageItem.memory(bytes: bytes, filename: 'local.jpg');
      expect(item.isMemory, isTrue);
      expect(item.isNetwork, isFalse);
      expect(item.bytes, bytes);
      expect(item.filename, 'local.jpg');
      expect(item.url, isNull);
    });
  });

  group('BatchDesignItem', () {
    test('computes totalStock correctly', () {
      const design = BatchDesignItem(
        id: 'd1',
        name: 'Negro',
        sizes: [
          ProductSizeEntity(size: 'S', stock: 4),
          ProductSizeEntity(size: 'M', stock: 6),
          ProductSizeEntity(size: 'L', stock: 10),
        ],
      );
      expect(design.totalStock, 20);
      expect(design.isValid, isTrue);
    });

    test('isValid is false when name is empty or sizes are empty', () {
      const emptyName = BatchDesignItem(
        id: 'd1',
        name: '   ',
        sizes: [ProductSizeEntity(size: 'S', stock: 2)],
      );
      expect(emptyName.isValid, isFalse);

      const noSizes = BatchDesignItem(
        id: 'd2',
        name: 'Rojo',
        sizes: [],
      );
      expect(noSizes.isValid, isFalse);
    });

    test('copyWith updates fields correctly', () {
      const design = BatchDesignItem(
        id: 'd1',
        name: 'Negro',
        sizes: [],
      );
      final updated = design.copyWith(
        name: 'Azul Marino',
        sizes: [const ProductSizeEntity(size: 'M', stock: 3)],
      );
      expect(updated.name, 'Azul Marino');
      expect(updated.sizes.length, 1);
      expect(updated.sizes.first.stock, 3);
    });

    test('supports solid color and switching to swatchImage with mutual exclusion', () {
      // Default initial has colorValue and no swatchImage
      const design = BatchDesignItem(
        id: 'd1',
        name: 'Rojo Pasión',
        colorValue: 0xFFE53935,
      );
      expect(design.colorValue, 0xFFE53935);
      expect(design.swatchImage, isNull);
      expect(design.hasSwatchImage, isFalse);

      // Switching to swatchImage clears colorValue
      const swatch = BatchImageItem.network('https://example.com/flower_pattern.jpg');
      final withSwatch = design.copyWith(
        swatchImage: swatch,
        clearColorValue: true,
      );
      expect(withSwatch.colorValue, isNull);
      expect(withSwatch.swatchImage, swatch);
      expect(withSwatch.hasSwatchImage, isTrue);

      // Switching back to color clears swatchImage
      final backToColor = withSwatch.copyWith(
        clearSwatchImage: true,
        colorValue: 0xFF1E88E5,
      );
      expect(backToColor.swatchImage, isNull);
      expect(backToColor.colorValue, 0xFF1E88E5);
      expect(backToColor.hasSwatchImage, isFalse);
    });
  });

  group('ProductBatchRowData', () {
    test('empty factory creates row with 1 initial design', () {
      final row = ProductBatchRowData.empty('temp_123');
      expect(row.tempId, 'temp_123');
      expect(row.designs.length, 1);
      expect(row.designs.first.name, 'Color único');
      expect(row.isValid, isFalse); // ID, name, basePrice are empty
    });

    test('fromProduct maps existing product designs and sizes', () {
      final product = ProductEntity(
        id: 'P-100',
        name: 'Vestido Seda',
        description: 'Hermoso vestido',
        basePrice: 89.90,
        discountPrice: 69.90,
        categoryIds: const ['cat_vestidos'],
        isVisible: true,
        createdAt: DateTime(2026, 1, 1),
        designs: const [
          ProductDesignEntity(
            id: 'design_black',
            name: 'Negro',
            imageUrls: ['https://example.com/black1.jpg'],
            sizes: [
              ProductSizeEntity(size: 'S', stock: 5),
              ProductSizeEntity(size: 'M', stock: 7),
            ],
          ),
          ProductDesignEntity(
            id: 'design_white',
            name: 'Blanco',
            imageUrls: ['https://example.com/white1.jpg'],
            sizes: [
              ProductSizeEntity(size: 'ESTÁNDAR', stock: 12),
            ],
          ),
        ],
      );

      final row = ProductBatchRowData.fromProduct('temp_1', product);

      expect(row.id, 'P-100');
      expect(row.name, 'Vestido Seda');
      expect(row.designs.length, 2);
      expect(row.designs[0].name, 'Negro');
      expect(row.designs[0].images.length, 1);
      expect(row.designs[0].images.first.url, 'https://example.com/black1.jpg');
      expect(row.designs[0].totalStock, 12);
      expect(row.designs[1].totalStock, 12);
      expect(row.totalStock, 24);
      expect(row.allImages.length, 2);
      expect(row.isValid, isTrue);
    });

    test('fromProduct preserves swatchImageUrl and clears colorValue when swatch exists', () {
      final productWithSwatch = ProductEntity(
        id: 'P-200',
        name: 'Falda Estampada',
        description: 'Falda fresca con diseño primaveral',
        basePrice: 45.0,
        categoryIds: const ['cat_faldas'],
        isVisible: true,
        createdAt: DateTime(2026, 1, 1),
        designs: const [
          ProductDesignEntity(
            id: 'd_floral',
            name: 'Floral',
            imageUrls: ['https://example.com/flower1.webp'],
            swatchImageUrl: 'https://example.com/flower_circle.webp',
            colorValue: null,
            sizes: [ProductSizeEntity(size: 'U', stock: 10)],
          ),
          ProductDesignEntity(
            id: 'd_solid',
            name: 'Azul',
            imageUrls: ['https://example.com/blue1.webp'],
            swatchImageUrl: null,
            colorValue: 0xFF2196F3,
            sizes: [ProductSizeEntity(size: 'U', stock: 5)],
          ),
        ],
      );

      final row = ProductBatchRowData.fromProduct('t_swatch', productWithSwatch);
      expect(row.designs[0].hasSwatchImage, isTrue);
      expect(row.designs[0].swatchImage?.url, 'https://example.com/flower_circle.webp');
      expect(row.designs[0].colorValue, isNull);

      expect(row.designs[1].hasSwatchImage, isFalse);
      expect(row.designs[1].swatchImage, isNull);
      expect(row.designs[1].colorValue, 0xFF2196F3);
    });

    test('isValid validation rules', () {
      final validRow = ProductBatchRowData(
        tempId: 't1',
        id: 'PROD-1',
        name: 'Pantalón Jean',
        basePrice: 50.0,
        designs: const [
          BatchDesignItem(
            id: 'd1',
            name: 'Azul',
            sizes: [ProductSizeEntity(size: '28', stock: 10)],
          ),
        ],
      );
      expect(validRow.isValid, isTrue);

      // Invalid if base price is 0
      expect(validRow.copyWith(basePrice: 0).isValid, isFalse);

      // Invalid if id is empty
      expect(validRow.copyWith(id: '').isValid, isFalse);

      // Invalid if name is empty
      expect(validRow.copyWith(name: '').isValid, isFalse);

      // Invalid if designs is empty
      expect(validRow.copyWith(designs: []).isValid, isFalse);

      // Invalid if any design has no sizes
      expect(
        validRow.copyWith(designs: [
          const BatchDesignItem(id: 'd1', name: 'Azul', sizes: []),
        ]).isValid,
        isFalse,
      );
    });
  });

  group('ProductBatchState', () {
    test('canSubmit is true only when all rows are valid', () {
      final validRow = ProductBatchRowData(
        tempId: 't1',
        id: 'PROD-1',
        name: 'Top',
        basePrice: 25.0,
        designs: const [
          BatchDesignItem(
            id: 'd1',
            name: 'Blanco',
            sizes: [ProductSizeEntity(size: 'S', stock: 5)],
          ),
        ],
      );

      final stateValid = ProductBatchState(
        mode: ProductBatchMode.create,
        rows: [validRow],
      );
      expect(stateValid.canSubmit, isTrue);
      expect(stateValid.invalidRowCount, 0);

      final invalidRow = ProductBatchRowData.empty('t2');
      final stateMixed = ProductBatchState(
        mode: ProductBatchMode.create,
        rows: [validRow, invalidRow],
      );
      expect(stateMixed.canSubmit, isFalse);
      expect(stateMixed.invalidRowCount, 1);
    });

    test('cloned product mapped with fromProduct in create mode is valid', () {
      final original = ProductEntity(
        id: 'PROD-100',
        name: 'Vestido Original',
        description: 'Hermoso vestido',
        basePrice: 89.90,
        categoryIds: const ['vestidos'],
        isVisible: true,
        createdAt: DateTime(2025, 1, 1),
        designs: const [
          ProductDesignEntity(
            id: 'd1',
            name: 'Rojo',
            imageUrls: ['https://example.com/red.jpg'],
            sizes: [ProductSizeEntity(size: 'M', stock: 8)],
          ),
        ],
      );

      final clone = original.copyWith(
        id: '${original.id}-COPIA',
        name: '${original.name} (Copia)',
        createdAt: DateTime.now(),
        deletedAt: null,
      );

      final row = ProductBatchRowData.fromProduct('temp_1', clone);
      expect(row.id, 'PROD-100-COPIA');
      expect(row.name, 'Vestido Original (Copia)');
      expect(row.basePrice, 89.90);
      expect(row.totalStock, 8);
      expect(row.designs.first.name, 'Rojo');
      expect(row.designs.first.images.first.url, 'https://example.com/red.jpg');
      expect(row.isValid, isTrue);
    });
  });
}
