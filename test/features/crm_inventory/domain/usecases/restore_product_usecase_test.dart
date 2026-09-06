import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/restore_product_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late RestoreProductUsecase usecase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    usecase = RestoreProductUsecase(repo: mockRepository);
  });

  group('RestoreProductUsecase Tests', () {
    test('should call repository.restoreProduct with the given id', () async {
      when(
        () => mockRepository.restoreProduct('PROD-001'),
      ).thenAnswer((_) async {});

      await usecase('PROD-001');

      verify(() => mockRepository.restoreProduct('PROD-001')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
