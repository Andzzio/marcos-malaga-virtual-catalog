import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:marcos_malaga_app/app/core/data/datasources/local_store_info_datasource.dart';
import 'package:marcos_malaga_app/app/core/data/repositories/local_store_info_repository_impl.dart';
import 'package:marcos_malaga_app/app/core/domain/repositories/store_info_repository.dart';
import 'package:marcos_malaga_app/app/core/domain/usecases/get_store_info_usecase.dart';

import 'package:marcos_malaga_app/app/core/data/datasources/local_legal_documents_datasource.dart';
import 'package:marcos_malaga_app/app/core/data/repositories/local_legal_documents_repository_impl.dart';
import 'package:marcos_malaga_app/app/core/domain/repositories/legal_documents_repository.dart';
import 'package:marcos_malaga_app/app/core/domain/usecases/get_legal_documents_usecase.dart';

import 'package:marcos_malaga_app/app/shared/data/datasources/local_products_datasource.dart';
import 'package:marcos_malaga_app/app/shared/data/repositories/local_products_repository_impl.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/get_products_usecase.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/get_product_by_id_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

final localStoreInfoDatasourceProvider = Provider<LocalStoreInfoDatasource>(
  (ref) => LocalStoreInfoDatasource(),
);
final storeInfoRepositoryProvider = Provider<StoreInfoRepository>(
  (ref) => LocalStoreInfoRepositoryImpl(
    datasource: ref.watch(localStoreInfoDatasourceProvider),
  ),
);
final getStoreInfoUsecaseProvider = Provider<GetStoreInfoUsecase>(
  (ref) => GetStoreInfoUsecase(repo: ref.watch(storeInfoRepositoryProvider)),
);

final localLegalDocumentsDatasourceProvider =
    Provider<LocalLegalDocumentsDatasource>(
      (ref) => LocalLegalDocumentsDatasource(),
    );
final legalDocumentsRepositoryProvider = Provider<LegalDocumentsRepository>(
  (ref) => LocalLegalDocumentsRepositoryImpl(
    datasource: ref.watch(localLegalDocumentsDatasourceProvider),
  ),
);
final getLegalDocumentsUsecaseProvider = Provider<GetLegalDocumentsUsecase>(
  (ref) => GetLegalDocumentsUsecase(
    repo: ref.watch(legalDocumentsRepositoryProvider),
  ),
);

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
final getProductByIdUsecaseProvider = Provider<GetProductByIdUsecase>(
  (ref) =>
      GetProductByIdUsecase(repo: ref.watch(localProductsRepositoryProvider)),
);
