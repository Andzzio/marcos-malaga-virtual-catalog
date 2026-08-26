import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:marcos_malaga_app/features/cart/domain/usecases/update_cart_item_quantity_usecase.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/cart_entity.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/cart_item_entity.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockCartRepository mockRepo;
  late UpdateCartItemQuantityUsecase usecase;

  const tItem = CartItemEntity(
    id: 'i1',
    productId: 'p1',
    designId: 'd1',
    sizeName: 'M',
    quantity: 2,
  );

  setUp(() {
    mockRepo = MockCartRepository();
    usecase = UpdateCartItemQuantityUsecase(mockRepo);
    registerFallbackValue(const CartEntity());
    when(() => mockRepo.saveCart(any())).thenAnswer((_) async {});
  });

  test('should update quantity of existing item', () async {
    const cart = CartEntity(items: [tItem]);
    when(() => mockRepo.getCart()).thenAnswer((_) async => cart);

    await usecase('i1', 5);

    final captured = verify(() => mockRepo.saveCart(captureAny())).captured;
    final savedCart = captured.first as CartEntity;
    expect(savedCart.items.first.quantity, 5);
  });

  test('should not modify quantity of other items', () async {
    const tItem2 = CartItemEntity(
      id: 'i2',
      productId: 'p2',
      designId: 'd2',
      sizeName: 'L',
      quantity: 3,
    );
    const cart = CartEntity(items: [tItem, tItem2]);
    when(() => mockRepo.getCart()).thenAnswer((_) async => cart);

    await usecase('i1', 10);

    final captured = verify(() => mockRepo.saveCart(captureAny())).captured;
    final savedCart = captured.first as CartEntity;
    expect(savedCart.items[0].quantity, 10);
    expect(savedCart.items[1].quantity, 3);
  });
}
