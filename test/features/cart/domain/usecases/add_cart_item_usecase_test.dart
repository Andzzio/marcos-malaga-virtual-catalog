import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/add_to_cart_result.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/cart_entity.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:marcos_malaga_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:marcos_malaga_app/features/cart/domain/usecases/add_cart_item_usecase.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late MockCartRepository mockRepo;
  late AddCartItemUsecase usecase;

  const tNewItem = CartItemEntity(
    id: 'p1_d1_M',
    productId: 'p1',
    designId: 'd1',
    sizeName: 'M',
    quantity: 2,
  );

  setUp(() {
    mockRepo = MockCartRepository();
    usecase = AddCartItemUsecase(mockRepo);
    registerFallbackValue(const CartEntity());
    when(() => mockRepo.saveCart(any())).thenAnswer((_) async {});
  });

  test('should add new item within stock returning added', () async {
    when(() => mockRepo.getCart()).thenAnswer((_) async => const CartEntity());

    final result = await usecase(tNewItem, maxStock: 5);

    expect(result, AddToCartResult.added);
    final captured = verify(() => mockRepo.saveCart(captureAny())).captured;
    final savedCart = captured.first as CartEntity;
    expect(savedCart.items.length, 1);
    expect(savedCart.items.first.productId, 'p1');
    expect(savedCart.items.first.quantity, 2);
  });

  test('should accumulate quantity when adding duplicate item within stock returning added', () async {
    const existingCart = CartEntity(items: [tNewItem]);
    when(() => mockRepo.getCart()).thenAnswer((_) async => existingCart);

    const duplicateItem = CartItemEntity(
      id: 'p1_d1_M',
      productId: 'p1',
      designId: 'd1',
      sizeName: 'M',
      quantity: 2,
    );

    final result = await usecase(duplicateItem, maxStock: 5);

    expect(result, AddToCartResult.added);
    final captured = verify(() => mockRepo.saveCart(captureAny())).captured;
    final savedCart = captured.first as CartEntity;
    expect(savedCart.items.length, 1);
    expect(savedCart.items.first.quantity, 4);
  });

  test('should clamp quantity to maxStock and return cappedToMax when sum exceeds stock', () async {
    const existingCart = CartEntity(items: [tNewItem]);
    when(() => mockRepo.getCart()).thenAnswer((_) async => existingCart);

    const duplicateItem = CartItemEntity(
      id: 'p1_d1_M',
      productId: 'p1',
      designId: 'd1',
      sizeName: 'M',
      quantity: 4,
    );

    final result = await usecase(duplicateItem, maxStock: 5);

    expect(result, AddToCartResult.cappedToMax);
    final captured = verify(() => mockRepo.saveCart(captureAny())).captured;
    final savedCart = captured.first as CartEntity;
    expect(savedCart.items.length, 1);
    expect(savedCart.items.first.quantity, 5);
  });

  test('should return alreadyAtMax and not save when existing item is already at max stock', () async {
    const maxedItem = CartItemEntity(
      id: 'p1_d1_M',
      productId: 'p1',
      designId: 'd1',
      sizeName: 'M',
      quantity: 5,
    );
    const existingCart = CartEntity(items: [maxedItem]);
    when(() => mockRepo.getCart()).thenAnswer((_) async => existingCart);

    const addItem = CartItemEntity(
      id: 'p1_d1_M',
      productId: 'p1',
      designId: 'd1',
      sizeName: 'M',
      quantity: 1,
    );

    final result = await usecase(addItem, maxStock: 5);

    expect(result, AddToCartResult.alreadyAtMax);
    verifyNever(() => mockRepo.saveCart(any()));
  });
}
