import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/core/data/datasources/local_legal_documents_datasource.dart';
import 'package:marcos_malaga_app/app/core/data/models/legal_document_model.dart';
import 'package:marcos_malaga_app/app/core/data/repositories/local_legal_documents_repository_impl.dart';

class FakeLocalLegalDocumentsDatasource implements LocalLegalDocumentsDatasource {
  @override
  Future<List<LegalDocumentModel>> fetchLegalDocuments() async {
    return [
      const LegalDocumentModel(id: '1', title: 'Fake', content: 'Fake Content'),
    ];
  }
}

void main() {
  late LocalLegalDocumentsRepositoryImpl repository;
  late FakeLocalLegalDocumentsDatasource fakeDatasource;

  setUp(() {
    fakeDatasource = FakeLocalLegalDocumentsDatasource();
    repository = LocalLegalDocumentsRepositoryImpl(datasource: fakeDatasource);
  });

  test('getLegalDocuments debe retornar List<LegalDocumentEntity>', () async {
    final result = await repository.getLegalDocuments();
    expect(result.length, 1);
    expect(result.first.title, 'Fake');
  });
}
