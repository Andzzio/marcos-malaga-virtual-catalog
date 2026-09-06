import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:marcos_malaga_app/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/cart_entity.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/cart_item_entity.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockCartRepository mockRepo;
  late RemoveCartItemUsecase usecase;

  const tItem1 = CartItemEntity(
    id: 'i1',
    productId: 'p1',
    designId: 'd1',
    sizeName: 'M',
    quantity: 2,
  );
  const tItem2 = CartItemEntity(
    id: 'i2',
    productId: 'p1',
    designId: 'd2',
    sizeName: 'M',
    quantity: 1,
  );

  setUp(() {
    mockRepo = MockCartRepository();
    usecase = RemoveCartItemUsecase(mockRepo);
    registerFallbackValue(const CartEntity());
    when(() => mockRepo.saveCart(any())).thenAnswer((_) async {});
  });

  test('should remove item by id from cart', () async {
    const cart = CartEntity(items: [tItem1, tItem2]);
    when(() => mockRepo.getCart()).thenAnswer((_) async => cart);

    await usecase('i1');

    final captured = verify(() => mockRepo.saveCart(captureAny())).captured;
    final savedCart = captured.first as CartEntity;
    expect(savedCart.items.length, 1);
    expect(savedCart.items.first.id, 'i2');
  });

  test('should result in empty cart when removing last item', () async {
    const cart = CartEntity(items: [tItem1]);
    when(() => mockRepo.getCart()).thenAnswer((_) async => cart);

    await usecase('i1');

    final captured = verify(() => mockRepo.saveCart(captureAny())).captured;
    final savedCart = captured.first as CartEntity;
    expect(savedCart.items, isEmpty);
  });

  test('should not modify cart when item id does not exist', () async {
    const cart = CartEntity(items: [tItem1]);
    when(() => mockRepo.getCart()).thenAnswer((_) async => cart);

    await usecase('nonexistent');

    final captured = verify(() => mockRepo.saveCart(captureAny())).captured;
    final savedCart = captured.first as CartEntity;
    expect(savedCart.items.length, 1);
  });
}
