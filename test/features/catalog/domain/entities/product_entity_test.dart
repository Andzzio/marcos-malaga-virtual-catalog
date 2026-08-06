import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_size_entity.dart';

void main() {
  group('Catalog Domain Entities Tests', () {
    const tSizeEntity = ProductSizeEntity(size: 'S', stock: 5, sku: 'SKU-1');
    const tDesignEntity = ProductDesignEntity(
      id: 'D-1',
      name: 'Vino',
      imageUrls: [],
      sizes: [tSizeEntity],
    );
    final tProductEntity = ProductEntity(
      id: 'P-1',
      name: 'Palazzo',
      description: 'Desc',
      basePrice: 100,
      categoryIds: [],
      designs: [tDesignEntity],
      isVisible: true,
      createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
    );

    test('ProductSizeEntity supports value equality', () {
      const size1 = ProductSizeEntity(size: 'S', stock: 5, sku: 'SKU-1');
      const size2 = ProductSizeEntity(size: 'S', stock: 5, sku: 'SKU-1');
      expect(size1, equals(size2));
    });

    test('ProductSizeEntity copyWith works correctly', () {
      final updated = tSizeEntity.copyWith(stock: 0);
      expect(updated.stock, 0);
      expect(updated.size, 'S');
      expect(updated, isNot(equals(tSizeEntity)));
    });

    test('ProductDesignEntity supports value equality', () {
      const design1 = ProductDesignEntity(
        id: 'D-1',
        name: 'Vino',
        imageUrls: [],
        sizes: [tSizeEntity],
      );
      const design2 = ProductDesignEntity(
        id: 'D-1',
        name: 'Vino',
        imageUrls: [],
        sizes: [tSizeEntity],
      );
      expect(design1, equals(design2));
    });

    test('ProductDesignEntity copyWith works correctly', () {
      final updated = tDesignEntity.copyWith(name: 'Negro');
      expect(updated.name, 'Negro');
      expect(updated.id, 'D-1');
      expect(updated, isNot(equals(tDesignEntity)));
    });

    test('ProductEntity supports value equality', () {
      final prod1 = ProductEntity(
        id: 'P-1',
        name: 'Palazzo',
        description: 'Desc',
        basePrice: 100,
        categoryIds: [],
        designs: [tDesignEntity],
        isVisible: true,
        createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );
      final prod2 = ProductEntity(
        id: 'P-1',
        name: 'Palazzo',
        description: 'Desc',
        basePrice: 100,
        categoryIds: [],
        designs: [tDesignEntity],
        isVisible: true,
        createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );
      expect(prod1, equals(prod2));
    });

    test('ProductEntity copyWith works correctly', () {
      final updated = tProductEntity.copyWith(basePrice: 80);
      expect(updated.basePrice, 80);
      expect(updated.name, 'Palazzo');
      expect(updated, isNot(equals(tProductEntity)));
    });
  });
}
