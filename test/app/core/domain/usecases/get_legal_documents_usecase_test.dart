import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/legal_document_entity.dart';
import 'package:marcos_malaga_app/app/core/domain/repositories/legal_documents_repository.dart';
import 'package:marcos_malaga_app/app/core/domain/usecases/get_legal_documents_usecase.dart';

class FakeLegalDocumentsRepository implements LegalDocumentsRepository {
  @override
  Future<List<LegalDocumentEntity>> getLegalDocuments() async {
    return [
      const LegalDocumentEntity(id: '1', title: 'Fake Usecase', content: 'Content'),
    ];
  }
}

void main() {
  late GetLegalDocumentsUsecase usecase;
  late FakeLegalDocumentsRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeLegalDocumentsRepository();
    usecase = GetLegalDocumentsUsecase(repo: fakeRepository);
  });

  test('call debe retornar List<LegalDocumentEntity> desde el repositorio', () async {
    final result = await usecase();
    expect(result.length, 1);
    expect(result.first.title, 'Fake Usecase');
  });
}
