import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/legal_document_entity.dart';
import 'package:marcos_malaga_app/app/core/presentation/providers/legal_documents_provider.dart';
import 'package:marcos_malaga_app/app/shared/widgets/placeholders/sliver_empty_placeholder.dart';

class LegalDocumentView extends ConsumerWidget {
  final String documentId;

  const LegalDocumentView({
    super.key,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(legalDocumentsProvider);

    return documentsAsync.when(
      data: (documents) {
        final LegalDocumentEntity? document =
            documents.where((d) => d.id == documentId).firstOrNull;

        if (document == null) {
          return const SliverEmptyPlaceholder(
            message: 'Documento no encontrado',
          );
        }

        return SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: ResponsiveTheme.isMobile(context) ||
                      ResponsiveTheme.isTablet(context)
                  ? const EdgeInsets.symmetric(horizontal: 20, vertical: 50)
                  : const EdgeInsets.symmetric(horizontal: 200, vertical: 50),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        document.title.toUpperCase(),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Gap(40),
                    Text(
                      document.content,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            height: 1.8,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, _) => const SliverEmptyPlaceholder(
        message: 'Error al cargar el documento',
      ),
    );
  }
}
