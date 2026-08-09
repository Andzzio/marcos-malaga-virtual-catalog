import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:marcos_malaga_app/app/core/utils/app_logger.dart';
import 'package:marcos_malaga_app/app/core/data/models/legal_document_model.dart';

class LocalLegalDocumentsDatasource {
  static const String _jsonRoute = 'assets/json/legal_documents.json';

  Future<List<LegalDocumentModel>> fetchLegalDocuments() async {
    final List<LegalDocumentModel> documents = [];
    late final String jsonString;
    try {
      jsonString = await rootBundle.loadString(_jsonRoute);
      final jsonDecoded = jsonDecode(jsonString);
      for (final entry in jsonDecoded) {
        documents.add(LegalDocumentModel.fromJson(entry));
      }
    } catch (e, stackTrace) {
      AppLogger.e(
        'A error has ocurred in opening "$_jsonRoute" at $stackTrace with error: $e',
      );
      return documents;
    }
    return documents;
  }
}
