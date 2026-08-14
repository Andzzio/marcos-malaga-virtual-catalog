import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/features/cart/data/datasources/local_cart_datasource.dart';
import 'package:marcos_malaga_app/features/cart/data/repositories/local_cart_repository_impl.dart';
import 'package:marcos_malaga_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:marcos_malaga_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:marcos_malaga_app/features/cart/domain/usecases/add_cart_item_usecase.dart';
import 'package:marcos_malaga_app/features/cart/domain/usecases/remove_cart_item_usecase.dart';
import 'package:marcos_malaga_app/features/cart/domain/usecases/update_cart_item_quantity_usecase.dart';
import 'package:marcos_malaga_app/providers/core/core_providers.dart';

final localCartDatasourceProvider = Provider<LocalCartDatasource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalCartDatasource(prefs: prefs);
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final datasource = ref.watch(localCartDatasourceProvider);
  return LocalCartRepositoryImpl(datasource);
});

final getCartUsecaseProvider = Provider<GetCartUsecase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return GetCartUsecase(repository);
});

final addCartItemUsecaseProvider = Provider<AddCartItemUsecase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return AddCartItemUsecase(repository);
});

final removeCartItemUsecaseProvider = Provider<RemoveCartItemUsecase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return RemoveCartItemUsecase(repository);
});

final updateCartItemQuantityUsecaseProvider = Provider<UpdateCartItemQuantityUsecase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return UpdateCartItemQuantityUsecase(repository);
});
