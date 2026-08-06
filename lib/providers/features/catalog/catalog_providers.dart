import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/features/catalog/data/datasources/local_banners_datasource.dart';
import 'package:marcos_malaga_app/features/catalog/data/datasources/local_products_datasource.dart';
import 'package:marcos_malaga_app/features/catalog/data/repositories/local_banners_repository_impl.dart';
import 'package:marcos_malaga_app/features/catalog/data/repositories/local_products_repository_impl.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/get_banners_usecase.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/get_products_usecase.dart';

final localProductsDatasourceProvider = Provider<LocalProductsDatasource>(
  (ref) => LocalProductsDatasource(),
);
final localProductsRepositoryProvider = Provider<ProductsRepository>(
  (ref) => LocalProductsRepositoryImpl(
    datasource: ref.watch(localProductsDatasourceProvider),
  ),
);
final getProductsUsecaseProvider = Provider<GetProductsUsecase>(
  (ref) => GetProductsUsecase(repo: ref.watch(localProductsRepositoryProvider)),
);

final localBannersDatasourceProvider = Provider<LocalBannersDatasource>(
  (ref) => LocalBannersDatasource(),
);
final localBannersRepositoryProvider = Provider<BannersRepository>(
  (ref) => LocalBannersRepositoryImpl(
    datasource: ref.watch(localBannersDatasourceProvider),
  ),
);
final getBannersUsecaseProvider = Provider<GetBannersUsecase>(
  (ref) => GetBannersUsecase(repo: ref.watch(localBannersRepositoryProvider)),
);
