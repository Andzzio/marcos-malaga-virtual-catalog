import 'package:marcos_malaga_app/app/core/domain/entities/legal_document_entity.dart';

class LegalDocumentModel {
  final String id;
  final String title;
  final String content;

  const LegalDocumentModel({
    required this.id,
    required this.title,
    required this.content,
  });

  factory LegalDocumentModel.fromJson(Map<String, dynamic> json) {
    return LegalDocumentModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'content': content};
  }

  LegalDocumentEntity toEntity() {
    return LegalDocumentEntity(id: id, title: title, content: content);
  }

  factory LegalDocumentModel.fromEntity(LegalDocumentEntity entity) {
    return LegalDocumentModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
    );
  }
}
