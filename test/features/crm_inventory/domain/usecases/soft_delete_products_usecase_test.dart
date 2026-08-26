import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/soft_delete_products_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late SoftDeleteProductsUsecase usecase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    usecase = SoftDeleteProductsUsecase(repo: mockRepository);
  });

  group('SoftDeleteProductsUsecase Tests', () {
    test('should call softDeleteProduct for each id in the list', () async {
      when(() => mockRepository.softDeleteProduct(any())).thenAnswer((_) async {});

      await usecase(['PROD-001', 'PROD-002', 'PROD-003']);

      verify(() => mockRepository.softDeleteProduct('PROD-001')).called(1);
      verify(() => mockRepository.softDeleteProduct('PROD-002')).called(1);
      verify(() => mockRepository.softDeleteProduct('PROD-003')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should do nothing when ids list is empty', () async {
      await usecase([]);
      verifyNever(() => mockRepository.softDeleteProduct(any()));
    });
  });
}
