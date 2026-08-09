import 'package:marcos_malaga_app/app/core/domain/entities/legal_document_entity.dart';
import 'package:marcos_malaga_app/app/core/domain/repositories/legal_documents_repository.dart';

class GetLegalDocumentsUsecase {
  final LegalDocumentsRepository repo;

  GetLegalDocumentsUsecase({required this.repo});

  Future<List<LegalDocumentEntity>> call() async {
    return await repo.getLegalDocuments();
  }
}
