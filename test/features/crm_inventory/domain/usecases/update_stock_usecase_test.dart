import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/update_stock_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late UpdateStockUsecase usecase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    usecase = UpdateStockUsecase(repo: mockRepository);
  });

  group('UpdateStockUsecase Tests', () {
    test('should call repository.updateStock with correct params', () async {
      when(() => mockRepository.updateStock(
        productId: 'PROD-001',
        designId: 'DES-001',
        sizeName: 'M',
        newStock: 10,
      )).thenAnswer((_) async {});

      await usecase(
        productId: 'PROD-001',
        designId: 'DES-001',
        sizeName: 'M',
        newStock: 10,
      );

      verify(() => mockRepository.updateStock(
        productId: 'PROD-001',
        designId: 'DES-001',
        sizeName: 'M',
        newStock: 10,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
