import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/core/data/models/legal_document_model.dart';

void main() {
  group('LegalDocumentModel from JSON del Disco', () {
    test('debe parsear correctamente el archivo real legal_documents.json', () {
      final file = File('assets/json/legal_documents.json');
      final jsonString = file.readAsStringSync();
      final jsonList = jsonDecode(jsonString) as List<dynamic>;

      final documents = jsonList.map((e) => LegalDocumentModel.fromJson(e)).toList();

      expect(documents, isNotEmpty);
      expect(documents.length, 3);
      expect(documents[0].id, 'privacy_policy');
      expect(documents[0].title, 'Política de Privacidad');
      expect(documents[0].content, contains('Marcos Malaga'));
    });
  });
}
