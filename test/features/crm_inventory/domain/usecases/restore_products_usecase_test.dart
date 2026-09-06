import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/restore_products_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late RestoreProductsUsecase usecase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    usecase = RestoreProductsUsecase(repo: mockRepository);
  });

  group('RestoreProductsUsecase Tests', () {
    test('should call restoreProduct for each id in the list', () async {
      when(() => mockRepository.restoreProduct(any())).thenAnswer((_) async {});

      await usecase(['PROD-001', 'PROD-002']);

      verify(() => mockRepository.restoreProduct('PROD-001')).called(1);
      verify(() => mockRepository.restoreProduct('PROD-002')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should do nothing when ids list is empty', () async {
      await usecase([]);
      verifyNever(() => mockRepository.restoreProduct(any()));
    });
  });
}
