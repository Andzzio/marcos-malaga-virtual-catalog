import 'package:marcos_malaga_app/app/core/domain/entities/legal_document_entity.dart';

abstract class LegalDocumentsRepository {
  Future<List<LegalDocumentEntity>> getLegalDocuments();
}
