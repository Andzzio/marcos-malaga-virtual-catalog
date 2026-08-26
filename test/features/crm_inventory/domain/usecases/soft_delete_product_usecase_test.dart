import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/soft_delete_product_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late SoftDeleteProductUsecase usecase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    usecase = SoftDeleteProductUsecase(repo: mockRepository);
  });

  group('SoftDeleteProductUsecase Tests', () {
    test('should call repository.softDeleteProduct with the given id', () async {
      when(() => mockRepository.softDeleteProduct('PROD-001')).thenAnswer((_) async {});

      await usecase('PROD-001');

      verify(() => mockRepository.softDeleteProduct('PROD-001')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
