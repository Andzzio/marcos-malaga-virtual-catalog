import 'package:equatable/equatable.dart';

class LegalDocumentEntity extends Equatable {
  final String id;
  final String title;
  final String content;

  const LegalDocumentEntity({
    required this.id,
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [id, title, content];
}
