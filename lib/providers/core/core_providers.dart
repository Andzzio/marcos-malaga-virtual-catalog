import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/app/shared/data/datasources/order/local_order_datasource.dart';
import 'package:marcos_malaga_app/app/shared/data/repositories/order/local_order_repository_impl.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/order_repository.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/order/create_order_usecase.dart';

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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';



import 'package:marcos_malaga_app/app/shared/data/services/image_processing_service_impl.dart';
import 'package:marcos_malaga_app/app/shared/domain/services/image_processing_service.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/process_banner_image_usecase.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/process_product_image_usecase.dart';
import 'package:marcos_malaga_app/app/shared/data/services/url_launcher_service_impl.dart';
import 'package:marcos_malaga_app/app/shared/domain/services/url_launcher_service.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/launch_external_url_usecase.dart';


import 'package:marcos_malaga_app/app/shared/data/datasources/firestore_products_datasource.dart';
import 'package:marcos_malaga_app/app/shared/data/repositories/firestore_products_repository_impl.dart';
import 'package:marcos_malaga_app/app/shared/data/datasources/firebase_storage_datasource.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/product_images_repository.dart';
import 'package:marcos_malaga_app/app/shared/data/repositories/firebase_product_images_repository_impl.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/upload_product_image_usecase.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
);

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
  (ref) => GetProductsUsecase(repo: ref.watch(firestoreProductsRepositoryProvider)),
);
final getProductByIdUsecaseProvider = Provider<GetProductByIdUsecase>(
  (ref) =>
      GetProductByIdUsecase(repo: ref.watch(firestoreProductsRepositoryProvider)),
);
final getProductDesignByIdUseCaseProvider =
    Provider<GetProductDesignByIdUseCase>(
      (ref) => GetProductDesignByIdUseCase(
        repo: ref.watch(firestoreProductsRepositoryProvider),
      ),
    );
final getProductSizeByNameUseCaseProvider =
    Provider<GetProductSizeByNameUseCase>(
      (ref) => GetProductSizeByNameUseCase(
        repo: ref.watch(firestoreProductsRepositoryProvider),
      ),
    );

// --- CRM Inventory: Write Use Cases ---
final createProductUsecaseProvider = Provider<CreateProductUsecase>(
  (ref) =>
      CreateProductUsecase(repo: ref.watch(firestoreProductsRepositoryProvider)),
);
final updateProductUsecaseProvider = Provider<UpdateProductUsecase>(
  (ref) =>
      UpdateProductUsecase(repo: ref.watch(firestoreProductsRepositoryProvider)),
);
final softDeleteProductUsecaseProvider = Provider<SoftDeleteProductUsecase>(
  (ref) => SoftDeleteProductUsecase(
    repo: ref.watch(firestoreProductsRepositoryProvider),
  ),
);
final restoreProductUsecaseProvider = Provider<RestoreProductUsecase>(
  (ref) =>
      RestoreProductUsecase(repo: ref.watch(firestoreProductsRepositoryProvider)),
);
final updateStockUsecaseProvider = Provider<UpdateStockUsecase>(
  (ref) => UpdateStockUsecase(repo: ref.watch(firestoreProductsRepositoryProvider)),
);
final createProductsUsecaseProvider = Provider<CreateProductsUsecase>(
  (ref) =>
      CreateProductsUsecase(repo: ref.watch(firestoreProductsRepositoryProvider)),
);
final softDeleteProductsUsecaseProvider = Provider<SoftDeleteProductsUsecase>(
  (ref) => SoftDeleteProductsUsecase(
    repo: ref.watch(firestoreProductsRepositoryProvider),
  ),
);
final restoreProductsUsecaseProvider = Provider<RestoreProductsUsecase>(
  (ref) =>
      RestoreProductsUsecase(repo: ref.watch(firestoreProductsRepositoryProvider)),
);

final localOrderDatasourceProvider = Provider<LocalOrderDatasource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalOrderDatasource(prefs: prefs);
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final datasource = ref.watch(localOrderDatasourceProvider);
  return LocalOrderRepositoryImpl(datasource);
});

final createOrderUseCaseProvider = Provider<CreateOrderUseCase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return CreateOrderUseCase(repository);
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'default',
  ),
);

final firestoreProductsDatasourceProvider = Provider<FirestoreProductsDatasource>(
  (ref) => FirestoreProductsDatasource(ref.watch(firebaseFirestoreProvider)),
);

final firestoreProductsRepositoryProvider = Provider<FirestoreProductsRepositoryImpl>(
  (ref) => FirestoreProductsRepositoryImpl(ref.watch(firestoreProductsDatasourceProvider)),
);

final firebaseStorageProvider = Provider<FirebaseStorage>(
  (ref) => FirebaseStorage.instanceFor(
    app: Firebase.app(),
    bucket: 'marcos-malaga-app.firebasestorage.app',
  ),
);

final firebaseStorageDatasourceProvider = Provider<FirebaseStorageDatasource>(
  (ref) => FirebaseStorageDatasource(ref.watch(firebaseStorageProvider)),
);

final imageProcessingServiceProvider = Provider<ImageProcessingService>(
  (ref) => const ImageProcessingServiceImpl(),
);

final processBannerImageUsecaseProvider = Provider<ProcessBannerImageUsecase>(
  (ref) => ProcessBannerImageUsecase(service: ref.watch(imageProcessingServiceProvider)),
);

final processProductImageUsecaseProvider = Provider<ProcessProductImageUsecase>(
  (ref) => ProcessProductImageUsecase(service: ref.watch(imageProcessingServiceProvider)),
);

final productImagesRepositoryProvider = Provider<ProductImagesRepository>(
  (ref) => FirebaseProductImagesRepositoryImpl(
    ref.watch(firebaseStorageDatasourceProvider),
    imageService: ref.watch(imageProcessingServiceProvider),
  ),
);

final uploadProductImageUsecaseProvider = Provider<UploadProductImageUsecase>(
  (ref) => UploadProductImageUsecase(repo: ref.watch(productImagesRepositoryProvider)),
);

final urlLauncherServiceProvider = Provider<UrlLauncherService>(
  (ref) => const UrlLauncherServiceImpl(),
);

final launchExternalUrlUsecaseProvider = Provider<LaunchExternalUrlUsecase>(
  (ref) => LaunchExternalUrlUsecase(service: ref.watch(urlLauncherServiceProvider)),
);



