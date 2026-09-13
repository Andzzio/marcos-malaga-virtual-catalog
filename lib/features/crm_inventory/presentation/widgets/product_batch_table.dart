import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/product_batch_state.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/widgets/product_batch_row.dart';

class ProductBatchTable extends StatefulWidget {
  final List<ProductBatchRowData> rows;
  final bool isEditMode;
  final ValueChanged<String> Function(String tempId) onIdChanged;
  final ValueChanged<String> Function(String tempId) onNameChanged;
  final ValueChanged<String> Function(String tempId) onDescriptionChanged;
  final ValueChanged<String> Function(String tempId) onBasePriceChanged;
  final ValueChanged<String> Function(String tempId) onDiscountPriceChanged;
  final ValueChanged<bool> Function(String tempId) onVisibilityChanged;
  final ValueChanged<List<BatchDesignItem>> Function(String tempId) onDesignsChanged;
  final ValueChanged<List<String>> Function(String tempId) onCategoriesChanged;
  final ValueChanged<String>? onRemoveRow;

  const ProductBatchTable({
    super.key,
    required this.rows,
    required this.isEditMode,
    required this.onIdChanged,
    required this.onNameChanged,
    required this.onDescriptionChanged,
    required this.onBasePriceChanged,
    required this.onDiscountPriceChanged,
    required this.onVisibilityChanged,
    required this.onDesignsChanged,
    required this.onCategoriesChanged,
    this.onRemoveRow,
  });

  static const double _totalWidth = 1740;

  @override
  State<ProductBatchTable> createState() => _ProductBatchTableState();
}

class _ProductBatchTableState extends State<ProductBatchTable> {
  final _horizontalController = ScrollController();
  final _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: 11,
    );

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      child: Scrollbar(
        controller: _horizontalController,
        thumbVisibility: true,
        notificationPredicate: (notification) => notification.depth == 0,
        child: SingleChildScrollView(
          controller: _horizontalController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: ProductBatchTable._totalWidth,
            child: Column(
              children: [
                _buildHeader(style),
                Expanded(
                  child: Scrollbar(
                    controller: _verticalController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _verticalController,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.rows.asMap().entries.map((entry) {
                          final index = entry.key;
                          final row = entry.value;
                          return ProductBatchRow(
                            key: ValueKey(row.tempId),
                            index: index,
                            row: row,
                            isEditMode: widget.isEditMode,
                            onIdChanged: widget.onIdChanged(row.tempId),
                            onNameChanged: widget.onNameChanged(row.tempId),
                            onDescriptionChanged:
                                widget.onDescriptionChanged(row.tempId),
                            onBasePriceChanged:
                                widget.onBasePriceChanged(row.tempId),
                            onDiscountPriceChanged:
                                widget.onDiscountPriceChanged(row.tempId),
                            onVisibilityChanged:
                                widget.onVisibilityChanged(row.tempId),
                            onDesignsChanged:
                                widget.onDesignsChanged(row.tempId),
                            onCategoriesChanged:
                                widget.onCategoriesChanged(row.tempId),
                            onRemove: !widget.isEditMode &&
                                    widget.rows.length > 1
                                ? () =>
                                    widget.onRemoveRow?.call(row.tempId)
                                : null,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TextStyle? style) {
    final headerStyle = style?.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade700,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
      ),
      child: Row(
        children: [
          _headerCell('#', 50, headerStyle),
          _headerCell('Diseños', 220, headerStyle),
          _headerCell('ID', 160, headerStyle),
          _headerCell('Nombre', 260, headerStyle),
          _headerCell('Descripción', 400, headerStyle),
          _headerCell('Precio Base', 140, headerStyle),
          _headerCell('Precio Oferta', 140, headerStyle),
          _headerCell('Categorías', 220, headerStyle),
          _headerCell('Visible', 90, headerStyle),
          _headerCell('', 60, headerStyle),
        ],
      ),
    );
  }

  Widget _headerCell(String label, double width, TextStyle? style) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Text(label, style: style),
    );
  }
}
