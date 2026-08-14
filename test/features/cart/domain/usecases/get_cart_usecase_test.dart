import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:marcos_malaga_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/cart_entity.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockCartRepository repository;
  late GetCartUsecase usecase;

  setUp(() {
    repository = MockCartRepository();
    usecase = GetCartUsecase(repository);
  });

  test('should get cart from repository', () async {
    const tCart = CartEntity();
    when(() => repository.getCart()).thenAnswer((_) async => tCart);

    final result = await usecase();

    expect(result, tCart);
    verify(() => repository.getCart()).called(1);
  });
}
