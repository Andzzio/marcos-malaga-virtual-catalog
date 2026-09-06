import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/cart/data/repositories/local_cart_repository_impl.dart';
import 'package:marcos_malaga_app/features/cart/data/datasources/local_cart_datasource.dart';
import 'package:marcos_malaga_app/features/cart/data/models/cart_model.dart';
import 'package:marcos_malaga_app/features/cart/data/models/cart_item_model.dart';

class MockLocalCartDatasource extends Mock implements LocalCartDatasource {}

void main() {
  late MockLocalCartDatasource mockDatasource;
  late LocalCartRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockLocalCartDatasource();
    repository = LocalCartRepositoryImpl(mockDatasource);
  });

  test('should get lean cart entity', () async {
    final tCartModel = CartModel(
      items: [
        CartItemModel(
          id: 'i1',
          productId: 'p1',
          designId: 'd1',
          sizeName: 'M',
          quantity: 2,
        ),
      ],
    );

    when(() => mockDatasource.getCart()).thenAnswer((_) async => tCartModel);

    final result = await repository.getCart();

    expect(result.items.length, 1);
    expect(result.items.first.productId, 'p1');
    expect(result.items.first.designId, 'd1');
    expect(result.items.first.sizeName, 'M');
  });
}
