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
import 'package:marcos_malaga_app/app/shared/domain/usecases/get_product_design_by_id_usecase.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/get_product_size_by_name_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/create_product_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/update_product_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/soft_delete_product_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/restore_product_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/update_stock_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/create_products_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/soft_delete_products_usecase.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/restore_products_usecase.dart';
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
final getProductDesignByIdUseCaseProvider = Provider<GetProductDesignByIdUseCase>(
  (ref) => GetProductDesignByIdUseCase(repo: ref.watch(localProductsRepositoryProvider)),
);
final getProductSizeByNameUseCaseProvider = Provider<GetProductSizeByNameUseCase>(
  (ref) => GetProductSizeByNameUseCase(repo: ref.watch(localProductsRepositoryProvider)),
);

// --- CRM Inventory: Write Use Cases ---
final createProductUsecaseProvider = Provider<CreateProductUsecase>(
  (ref) => CreateProductUsecase(repo: ref.watch(localProductsRepositoryProvider)),
);
final updateProductUsecaseProvider = Provider<UpdateProductUsecase>(
  (ref) => UpdateProductUsecase(repo: ref.watch(localProductsRepositoryProvider)),
);
final softDeleteProductUsecaseProvider = Provider<SoftDeleteProductUsecase>(
  (ref) => SoftDeleteProductUsecase(repo: ref.watch(localProductsRepositoryProvider)),
);
final restoreProductUsecaseProvider = Provider<RestoreProductUsecase>(
  (ref) => RestoreProductUsecase(repo: ref.watch(localProductsRepositoryProvider)),
);
final updateStockUsecaseProvider = Provider<UpdateStockUsecase>(
  (ref) => UpdateStockUsecase(repo: ref.watch(localProductsRepositoryProvider)),
);
final createProductsUsecaseProvider = Provider<CreateProductsUsecase>(
  (ref) => CreateProductsUsecase(repo: ref.watch(localProductsRepositoryProvider)),
);
final softDeleteProductsUsecaseProvider = Provider<SoftDeleteProductsUsecase>(
  (ref) => SoftDeleteProductsUsecase(repo: ref.watch(localProductsRepositoryProvider)),
);
final restoreProductsUsecaseProvider = Provider<RestoreProductsUsecase>(
  (ref) => RestoreProductsUsecase(repo: ref.watch(localProductsRepositoryProvider)),
);
