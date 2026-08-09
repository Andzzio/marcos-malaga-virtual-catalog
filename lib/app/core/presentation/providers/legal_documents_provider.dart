import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/legal_document_entity.dart';
import 'package:marcos_malaga_app/providers/core/core_providers.dart';

class LegalDocumentsProvider extends AsyncNotifier<List<LegalDocumentEntity>> {
  @override
  Future<List<LegalDocumentEntity>> build() async {
    return await ref.watch(getLegalDocumentsUsecaseProvider).call();
  }
}

final legalDocumentsProvider =
    AsyncNotifierProvider<LegalDocumentsProvider, List<LegalDocumentEntity>>(
      LegalDocumentsProvider.new,
    );
