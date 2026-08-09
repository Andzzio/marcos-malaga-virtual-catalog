import 'package:marcos_malaga_app/app/core/data/datasources/local_legal_documents_datasource.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/legal_document_entity.dart';
import 'package:marcos_malaga_app/app/core/domain/repositories/legal_documents_repository.dart';

class LocalLegalDocumentsRepositoryImpl implements LegalDocumentsRepository {
  final LocalLegalDocumentsDatasource datasource;

  LocalLegalDocumentsRepositoryImpl({required this.datasource});

  @override
  Future<List<LegalDocumentEntity>> getLegalDocuments() async {
    final models = await datasource.fetchLegalDocuments();
    return models.map((m) => m.toEntity()).toList();
  }
}
