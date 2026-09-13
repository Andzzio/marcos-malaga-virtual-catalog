import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/inventory_screen_provider.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/inventory_screen_state.dart';

ProductEntity _createSampleProduct(String id, String name, double price) {
  return ProductEntity(
    id: id,
    name: name,
    description: 'Description of $name',
    basePrice: price,
    discountPrice: null,
    categoryIds: const ['cat1'],
    isVisible: true,
    createdAt: DateTime(2025, 1, 1),
    designs: const [
      ProductDesignEntity(
        id: 'd1',
        name: 'Design 1',
        imageUrls: ['https://example.com/img.jpg'],
        sizes: [ProductSizeEntity(size: 'M', stock: 10)],
      ),
    ],
  );
}

void main() {
  group('InventoryScreenState', () {
    test('default values', () {
      const state = InventoryScreenState();
      expect(state.selectedProductIds, isEmpty);
      expect(state.searchQuery, isEmpty);
      expect(state.selectedFilter, 'Todos');
      expect(state.pendingEdits, isEmpty);
      expect(state.isSaving, isFalse);
      expect(state.hasPendingEdits, isFalse);
      expect(state.pendingEditsCount, 0);
    });

    test('pendingEdits getters', () {
      final p1 = _createSampleProduct('p1', 'Prod 1', 10.0);
      final p2 = _createSampleProduct('p2', 'Prod 2', 20.0);

      final state = const InventoryScreenState().copyWith(
        pendingEdits: {'p1': p1, 'p2': p2},
      );

      expect(state.hasPendingEdits, isTrue);
      expect(state.pendingEditsCount, 2);
    });
  });

  group('InventoryScreenProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('toggleSelection adds and removes product IDs', () {
      final notifier = container.read(inventoryScreenProvider.notifier);

      expect(container.read(inventoryScreenProvider).selectedProductIds, isEmpty);

      notifier.toggleSelection('prod-1');
      expect(
        container.read(inventoryScreenProvider).selectedProductIds,
        contains('prod-1'),
      );

      notifier.toggleSelection('prod-2');
      expect(
        container.read(inventoryScreenProvider).selectedProductIds,
        containsAll(['prod-1', 'prod-2']),
      );

      notifier.toggleSelection('prod-1');
      expect(
        container.read(inventoryScreenProvider).selectedProductIds,
        isNot(contains('prod-1')),
      );
      expect(
        container.read(inventoryScreenProvider).selectedProductIds,
        contains('prod-2'),
      );
    });

    test('clearSelection removes all selected product IDs', () {
      final notifier = container.read(inventoryScreenProvider.notifier);
      notifier.toggleSelection('p1');
      notifier.toggleSelection('p2');
      expect(container.read(inventoryScreenProvider).selectedProductIds.length, 2);

      notifier.clearSelection();
      expect(container.read(inventoryScreenProvider).selectedProductIds, isEmpty);
    });

    test('updateSearchQuery and updateFilter update corresponding fields', () {
      final notifier = container.read(inventoryScreenProvider.notifier);
      notifier.updateSearchQuery('vestido');
      expect(container.read(inventoryScreenProvider).searchQuery, 'vestido');

      notifier.updateFilter('Destacados');
      expect(container.read(inventoryScreenProvider).selectedFilter, 'Destacados');
    });

    test('stages multiple product drafts and updates pendingEdits count', () {
      final notifier = container.read(inventoryScreenProvider.notifier);
      final p1 = _createSampleProduct('p1', 'Original 1', 10.0);
      final p2 = _createSampleProduct('p2', 'Original 2', 20.0);
      final p3 = _createSampleProduct('p3', 'Original 3', 30.0);
      final p4 = _createSampleProduct('p4', 'Original 4', 40.0);

      notifier.updateProductDraft(p1.copyWith(name: 'Edited 1'));
      notifier.updateProductDraft(p2.copyWith(basePrice: 25.0));
      notifier.updateProductDraft(p3.copyWith(name: 'Edited 3'));
      notifier.updateProductDraft(p4.copyWith(discountPrice: 35.0));

      final state = container.read(inventoryScreenProvider);
      expect(state.hasPendingEdits, isTrue);
      expect(state.pendingEditsCount, 4);
      expect(state.pendingEdits['p1']?.name, 'Edited 1');
      expect(state.pendingEdits['p2']?.basePrice, 25.0);
      expect(state.pendingEdits['p3']?.name, 'Edited 3');
      expect(state.pendingEdits['p4']?.discountPrice, 35.0);
    });

    test('discardDraft removes draft for specific product', () {
      final notifier = container.read(inventoryScreenProvider.notifier);
      final p1 = _createSampleProduct('p1', 'Prod 1', 10.0);
      final p2 = _createSampleProduct('p2', 'Prod 2', 20.0);

      notifier.updateProductDraft(p1);
      notifier.updateProductDraft(p2);
      expect(container.read(inventoryScreenProvider).pendingEditsCount, 2);

      notifier.discardDraft('p1');
      expect(container.read(inventoryScreenProvider).pendingEditsCount, 1);
      expect(container.read(inventoryScreenProvider).pendingEdits.containsKey('p1'), isFalse);
      expect(container.read(inventoryScreenProvider).pendingEdits.containsKey('p2'), isTrue);
    });

    test('discardAllDrafts clears all pending drafts', () {
      final notifier = container.read(inventoryScreenProvider.notifier);
      final p1 = _createSampleProduct('p1', 'Prod 1', 10.0);
      final p2 = _createSampleProduct('p2', 'Prod 2', 20.0);

      notifier.updateProductDraft(p1);
      notifier.updateProductDraft(p2);

      notifier.discardAllDrafts();
      expect(container.read(inventoryScreenProvider).hasPendingEdits, isFalse);
      expect(container.read(inventoryScreenProvider).pendingEdits, isEmpty);
    });
  });

  group('filteredInventoryProductsProvider Tests', () {
    test('filters by status and stock correctly', () async {
      final p1 = _createSampleProduct('p1', 'Camisa Blanca', 50.0).copyWith(
        isVisible: true,
        designs: const [
          ProductDesignEntity(
            id: 'd1',
            name: 'Color',
            imageUrls: ['https://example.com/img1.jpg'],
            colorValue: 0xFFFFFFFF,
            sizes: [ProductSizeEntity(size: 'M', stock: 10)],
          ),
        ],
      );
      final p2 = _createSampleProduct('p2', 'Pantalón Negro', 80.0).copyWith(
        isVisible: false,
        designs: const [
          ProductDesignEntity(
            id: 'd2',
            name: 'Color',
            imageUrls: ['https://example.com/img2.jpg'],
            colorValue: 0xFF000000,
            sizes: [ProductSizeEntity(size: '32', stock: 0)],
          ),
        ],
      );
      final p3 = _createSampleProduct('p3', 'Vestido Rojo', 120.0).copyWith(
        isVisible: true,
        deletedAt: DateTime(2025, 2, 1),
      );

      final container = ProviderContainer(
        overrides: [
          productsProvider.overrideWith(() => _FakeProductsNotifier([p1, p2, p3])),
        ],
      );

      // Wait for products to load
      await container.read(productsProvider.future);

      // Default 'Todos': p1 and p2 (active products, excludes deleted p3)
      final allFiltered = container.read(filteredInventoryProductsProvider).value!;
      expect(allFiltered.map((p) => p.id), containsAll(['p1', 'p2']));
      expect(allFiltered.map((p) => p.id), isNot(contains('p3')));

      // 'Visibles'
      container.read(inventoryScreenProvider.notifier).updateFilter('Visibles');
      final visible = container.read(filteredInventoryProductsProvider).value!;
      expect(visible.map((p) => p.id), equals(['p1']));

      // 'Ocultos'
      container.read(inventoryScreenProvider.notifier).updateFilter('Ocultos');
      final hidden = container.read(filteredInventoryProductsProvider).value!;
      expect(hidden.map((p) => p.id), equals(['p2']));

      // 'Con stock'
      container.read(inventoryScreenProvider.notifier).updateFilter('Con stock');
      final withStock = container.read(filteredInventoryProductsProvider).value!;
      expect(withStock.map((p) => p.id), equals(['p1']));

      // 'Sin stock'
      container.read(inventoryScreenProvider.notifier).updateFilter('Sin stock');
      final outStock = container.read(filteredInventoryProductsProvider).value!;
      expect(outStock.map((p) => p.id), equals(['p2']));

      // 'Papelera'
      container.read(inventoryScreenProvider.notifier).updateFilter('Papelera');
      final trash = container.read(filteredInventoryProductsProvider).value!;
      expect(trash.map((p) => p.id), equals(['p3']));

      // Search query
      container.read(inventoryScreenProvider.notifier).updateFilter('Todos');
      container.read(inventoryScreenProvider.notifier).updateSearchQuery('camisa');
      final searched = container.read(filteredInventoryProductsProvider).value!;
      expect(searched.map((p) => p.id), equals(['p1']));

      container.dispose();
    });
  });
}

class _FakeProductsNotifier extends AsyncNotifier<List<ProductEntity>>
    implements ProductsProvider {
  final List<ProductEntity> initialProducts;
  _FakeProductsNotifier(this.initialProducts);

  @override
  Future<List<ProductEntity>> build() async => initialProducts;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
