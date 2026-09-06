import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/get_products_usecase.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/create_product_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/create_products_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/update_product_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/soft_delete_product_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/soft_delete_products_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/restore_product_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/restore_products_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/update_stock_usecase.dart';
import 'package:marcos_malaga_app/providers/core/core_providers.dart';

class MockGetProductsUsecase extends Mock implements GetProductsUsecase {}

class MockCreateProductUsecase extends Mock implements CreateProductUsecase {}

class MockCreateProductsUsecase extends Mock implements CreateProductsUsecase {}

class MockUpdateProductUsecase extends Mock implements UpdateProductUsecase {}

class MockSoftDeleteProductUsecase extends Mock
    implements SoftDeleteProductUsecase {}

class MockSoftDeleteProductsUsecase extends Mock
    implements SoftDeleteProductsUsecase {}

class MockRestoreProductUsecase extends Mock implements RestoreProductUsecase {}

class MockRestoreProductsUsecase extends Mock
    implements RestoreProductsUsecase {}

class MockUpdateStockUsecase extends Mock implements UpdateStockUsecase {}

void main() {
  late MockGetProductsUsecase mockGetProducts;
  late MockCreateProductUsecase mockCreate;
  late MockCreateProductsUsecase mockCreateMany;
  late MockUpdateProductUsecase mockUpdate;
  late MockSoftDeleteProductUsecase mockSoftDelete;
  late MockSoftDeleteProductsUsecase mockSoftDeleteMany;
  late MockRestoreProductUsecase mockRestore;
  late MockRestoreProductsUsecase mockRestoreMany;
  late MockUpdateStockUsecase mockUpdateStock;

  final tProduct = ProductEntity(
    id: 'PROD-001',
    name: 'Vestido Test',
    description: 'Desc',
    basePrice: 100.0,
    categoryIds: const [],
    designs: const [],
    isVisible: true,
    createdAt: DateTime.parse('2025-01-01T00:00:00Z'),
    deletedAt: null,
  );

  setUp(() {
    mockGetProducts = MockGetProductsUsecase();
    mockCreate = MockCreateProductUsecase();
    mockCreateMany = MockCreateProductsUsecase();
    mockUpdate = MockUpdateProductUsecase();
    mockSoftDelete = MockSoftDeleteProductUsecase();
    mockSoftDeleteMany = MockSoftDeleteProductsUsecase();
    mockRestore = MockRestoreProductUsecase();
    mockRestoreMany = MockRestoreProductsUsecase();
    mockUpdateStock = MockUpdateStockUsecase();

    when(() => mockGetProducts.call()).thenAnswer((_) async => [tProduct]);
    registerFallbackValue(tProduct);
    registerFallbackValue(<ProductEntity>[]);
    registerFallbackValue(<String>[]);
  });

  ProviderContainer makeContainer() => ProviderContainer(
    overrides: [
      getProductsUsecaseProvider.overrideWithValue(mockGetProducts),
      createProductUsecaseProvider.overrideWithValue(mockCreate),
      createProductsUsecaseProvider.overrideWithValue(mockCreateMany),
      updateProductUsecaseProvider.overrideWithValue(mockUpdate),
      softDeleteProductUsecaseProvider.overrideWithValue(mockSoftDelete),
      softDeleteProductsUsecaseProvider.overrideWithValue(mockSoftDeleteMany),
      restoreProductUsecaseProvider.overrideWithValue(mockRestore),
      restoreProductsUsecaseProvider.overrideWithValue(mockRestoreMany),
      updateStockUsecaseProvider.overrideWithValue(mockUpdateStock),
    ],
  );

  group('ProductsProvider Write Methods', () {
    test('createProduct calls usecase with product', () async {
      when(() => mockCreate.call(any())).thenAnswer((_) async {});
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(productsProvider.future);
      await container.read(productsProvider.notifier).createProduct(tProduct);
      verify(() => mockCreate.call(tProduct)).called(1);
    });

    test('createMany calls usecase with list of products', () async {
      when(() => mockCreateMany.call(any())).thenAnswer((_) async {});
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(productsProvider.future);
      await container.read(productsProvider.notifier).createMany([tProduct]);
      verify(() => mockCreateMany.call([tProduct])).called(1);
    });

    test('updateProduct calls usecase with product', () async {
      when(() => mockUpdate.call(any())).thenAnswer((_) async {});
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(productsProvider.future);
      await container.read(productsProvider.notifier).updateProduct(tProduct);
      verify(() => mockUpdate.call(tProduct)).called(1);
    });

    test('softDelete calls usecase with id', () async {
      when(() => mockSoftDelete.call(any())).thenAnswer((_) async {});
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(productsProvider.future);
      await container.read(productsProvider.notifier).softDelete('PROD-001');
      verify(() => mockSoftDelete.call('PROD-001')).called(1);
    });

    test('softDeleteMany calls usecase with list of ids', () async {
      when(() => mockSoftDeleteMany.call(any())).thenAnswer((_) async {});
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(productsProvider.future);
      await container.read(productsProvider.notifier).softDeleteMany([
        'PROD-001',
        'PROD-002',
      ]);
      verify(() => mockSoftDeleteMany.call(['PROD-001', 'PROD-002'])).called(1);
    });

    test('restore calls usecase with id', () async {
      when(() => mockRestore.call(any())).thenAnswer((_) async {});
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(productsProvider.future);
      await container.read(productsProvider.notifier).restore('PROD-001');
      verify(() => mockRestore.call('PROD-001')).called(1);
    });

    test('restoreMany calls usecase with list of ids', () async {
      when(() => mockRestoreMany.call(any())).thenAnswer((_) async {});
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(productsProvider.future);
      await container.read(productsProvider.notifier).restoreMany([
        'PROD-001',
        'PROD-002',
      ]);
      verify(() => mockRestoreMany.call(['PROD-001', 'PROD-002'])).called(1);
    });

    test('updateStock calls usecase with correct params', () async {
      when(
        () => mockUpdateStock.call(
          productId: any(named: 'productId'),
          designId: any(named: 'designId'),
          sizeName: any(named: 'sizeName'),
          newStock: any(named: 'newStock'),
        ),
      ).thenAnswer((_) async {});
      final container = makeContainer();
      addTearDown(container.dispose);
      await container.read(productsProvider.future);
      await container
          .read(productsProvider.notifier)
          .updateStock(
            productId: 'PROD-001',
            designId: 'DES-001',
            sizeName: 'M',
            newStock: 10,
          );
      verify(
        () => mockUpdateStock.call(
          productId: 'PROD-001',
          designId: 'DES-001',
          sizeName: 'M',
          newStock: 10,
        ),
      ).called(1);
    });
  });
}
