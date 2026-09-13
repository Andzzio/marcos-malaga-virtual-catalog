import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/features/catalog/data/datasources/firestore_banners_datasource.dart';
import 'package:marcos_malaga_app/features/catalog/data/repositories/firestore_banners_repository_impl.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/create_banner_usecase.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/delete_banner_usecase.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/get_banners_usecase.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/reorder_banners_usecase.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/update_banner_usecase.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/upload_banner_media_usecase.dart';
import 'package:marcos_malaga_app/providers/core/core_providers.dart';

final firestoreBannersDatasourceProvider = Provider<FirestoreBannersDatasource>(
  (ref) => FirestoreBannersDatasource(ref.watch(firebaseFirestoreProvider)),
);

final bannersRepositoryProvider = Provider<BannersRepository>(
  (ref) => FirestoreBannersRepositoryImpl(
    datasource: ref.watch(firestoreBannersDatasourceProvider),
  ),
);

final getBannersUsecaseProvider = Provider<GetBannersUsecase>(
  (ref) => GetBannersUsecase(repo: ref.watch(bannersRepositoryProvider)),
);

final createBannerUsecaseProvider = Provider<CreateBannerUsecase>(
  (ref) => CreateBannerUsecase(repo: ref.watch(bannersRepositoryProvider)),
);

final updateBannerUsecaseProvider = Provider<UpdateBannerUsecase>(
  (ref) => UpdateBannerUsecase(repo: ref.watch(bannersRepositoryProvider)),
);

final deleteBannerUsecaseProvider = Provider<DeleteBannerUsecase>(
  (ref) => DeleteBannerUsecase(
    repo: ref.watch(bannersRepositoryProvider),
    storage: ref.watch(firebaseStorageDatasourceProvider),
  ),
);

final reorderBannersUsecaseProvider = Provider<ReorderBannersUsecase>(
  (ref) => ReorderBannersUsecase(repo: ref.watch(bannersRepositoryProvider)),
);

final uploadBannerMediaUsecaseProvider = Provider<UploadBannerMediaUsecase>(
  (ref) => UploadBannerMediaUsecase(
    storage: ref.watch(firebaseStorageDatasourceProvider),
    imageService: ref.watch(imageProcessingServiceProvider),
  ),
);

