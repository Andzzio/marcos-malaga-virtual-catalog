import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';

class ProductCategoriesDialog extends ConsumerStatefulWidget {
  final List<String> initialCategories;
  final ValueChanged<List<String>> onSave;

  const ProductCategoriesDialog({
    super.key,
    required this.initialCategories,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    required List<String> initialCategories,
    required ValueChanged<List<String>> onSave,
  }) {
    return showDialog(
      context: context,
      builder: (_) => ProductCategoriesDialog(
        initialCategories: initialCategories,
        onSave: onSave,
      ),
    );
  }

  @override
  ConsumerState<ProductCategoriesDialog> createState() =>
      _ProductCategoriesDialogState();
}

class _ProductCategoriesDialogState
    extends ConsumerState<ProductCategoriesDialog> {
  late final List<String> _categories;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _categories = List.from(widget.initialCategories);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addCategory([String? directValue]) {
    final value = (directValue ?? _textController.text).trim().toLowerCase();
    if (value.isNotEmpty && !_categories.contains(value)) {
      setState(() {
        _categories.add(value);
      });
      _textController.clear();
    }
  }

  void _removeCategory(String cat) {
    setState(() {
      _categories.remove(cat);
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: 12,
    );
    final primaryColor = Theme.of(context).colorScheme.primary;

    // Get all unique categories across existing products for suggestions
    final productsAsync = ref.watch(productsProvider);
    final Set<String> existingCategories = {};
    productsAsync.whenData((products) {
      for (final p in products) {
        existingCategories.addAll(p.categoryIds.map((c) => c.toLowerCase()));
      }
    });

    final suggested = existingCategories
        .where((c) => !_categories.contains(c))
        .toList()
      ..sort();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Administrar categorías',
                style: style?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Text(
                'Escribe una categoría nueva o selecciona de las existentes.',
                style: style?.copyWith(color: Colors.grey.shade600),
              ),
              const Gap(16),

              // Input row to add new category
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: style,
                      decoration: InputDecoration(
                        hintText: 'Nueva categoría (ej: vestidos, fiesta...)',
                        hintStyle:
                            style?.copyWith(color: Colors.grey.shade400),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onSubmitted: (_) => _addCategory(),
                    ),
                  ),
                  const Gap(8),
                  FilledButton.icon(
                    onPressed: () => _addCategory(),
                    icon: const Icon(Icons.add, size: 16),
                    label: Text('Añadir', style: style?.copyWith(color: Colors.white)),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(16),

              // Selected categories for this product
              Text(
                'Categorías asignadas (${_categories.length})',
                style: style?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const Gap(8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                constraints: const BoxConstraints(minHeight: 50, maxHeight: 120),
                child: _categories.isEmpty
                    ? Center(
                        child: Text(
                          'No hay categorías asignadas a este producto.',
                          style: style?.copyWith(color: Colors.grey.shade400),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _categories
                              .map(
                                (c) => Chip(
                                  label: Text(c, style: style),
                                  deleteIcon: const Icon(Icons.close, size: 14),
                                  onDeleted: () => _removeCategory(c),
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor:
                                      primaryColor.withValues(alpha: 0.1),
                                  side: BorderSide(
                                    color: primaryColor.withValues(alpha: 0.3),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
              ),
              const Gap(16),

              // Existing category suggestions from catalog
              if (suggested.isNotEmpty) ...[
                Text(
                  'Sugerencias del catálogo (haz clic para agregar)',
                  style: style?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const Gap(8),
                Flexible(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: suggested
                          .map(
                            (c) => ActionChip(
                              label: Text(c, style: style),
                              avatar: const Icon(Icons.add, size: 14),
                              onPressed: () => _addCategory(c),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const Gap(16),
              ],

              const Divider(height: 1),
              const Gap(16),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancelar', style: style),
                  ),
                  const Gap(8),
                  FilledButton(
                    onPressed: () {
                      widget.onSave(_categories);
                      Navigator.of(context).pop();
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Guardar',
                      style: style?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
