import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:marcos_malaga_app/app/core/data/datasources/local_store_info_datasource.dart';
import 'package:marcos_malaga_app/app/core/data/repositories/local_store_info_repository_impl.dart';
import 'package:marcos_malaga_app/app/core/domain/repositories/store_info_repository.dart';
import 'package:marcos_malaga_app/app/core/domain/usecases/get_store_info_usecase.dart';

import 'package:marcos_malaga_app/app/core/data/datasources/local_legal_documents_datasource.dart';
import 'package:marcos_malaga_app/app/core/data/repositories/local_legal_documents_repository_impl.dart';
import 'package:marcos_malaga_app/app/core/domain/repositories/legal_documents_repository.dart';
import 'package:marcos_malaga_app/app/core/domain/usecases/get_legal_documents_usecase.dart';

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
