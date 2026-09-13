import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/product_batch_state.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/widgets/product_designs_dialog.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/widgets/product_categories_dialog.dart';

class ProductBatchRow extends StatefulWidget {
  final int index;
  final ProductBatchRowData row;
  final bool isEditMode;
  final ValueChanged<String> onIdChanged;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onBasePriceChanged;
  final ValueChanged<String> onDiscountPriceChanged;
  final ValueChanged<bool> onVisibilityChanged;
  final ValueChanged<List<BatchDesignItem>> onDesignsChanged;
  final ValueChanged<List<String>> onCategoriesChanged;
  final VoidCallback? onRemove;

  const ProductBatchRow({
    super.key,
    required this.index,
    required this.row,
    required this.isEditMode,
    required this.onIdChanged,
    required this.onNameChanged,
    required this.onDescriptionChanged,
    required this.onBasePriceChanged,
    required this.onDiscountPriceChanged,
    required this.onVisibilityChanged,
    required this.onDesignsChanged,
    required this.onCategoriesChanged,
    this.onRemove,
  });

  @override
  State<ProductBatchRow> createState() => _ProductBatchRowState();
}

class _ProductBatchRowState extends State<ProductBatchRow> {
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _basePriceController;
  late final TextEditingController _discountPriceController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.row.id);
    _nameController = TextEditingController(text: widget.row.name);
    _descriptionController =
        TextEditingController(text: widget.row.description);
    _basePriceController = TextEditingController(
      text: widget.row.basePrice > 0
          ? widget.row.basePrice.toStringAsFixed(2)
          : '',
    );
    _discountPriceController = TextEditingController(
      text: widget.row.discountPrice != null && widget.row.discountPrice! > 0
          ? widget.row.discountPrice!.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void didUpdateWidget(ProductBatchRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.row.id != _idController.text) {
      _idController.text = widget.row.id;
    }
    if (widget.row.name != _nameController.text) {
      _nameController.text = widget.row.name;
    }
    if (widget.row.description != _descriptionController.text) {
      _descriptionController.text = widget.row.description;
    }
    final newBasePriceStr = widget.row.basePrice > 0
        ? widget.row.basePrice.toStringAsFixed(2)
        : '';
    if (newBasePriceStr != _basePriceController.text &&
        double.tryParse(_basePriceController.text) != widget.row.basePrice) {
      _basePriceController.text = newBasePriceStr;
    }
    final newDiscountStr =
        widget.row.discountPrice != null && widget.row.discountPrice! > 0
            ? widget.row.discountPrice!.toStringAsFixed(2)
            : '';
    if (newDiscountStr != _discountPriceController.text &&
        double.tryParse(_discountPriceController.text) !=
            widget.row.discountPrice) {
      _discountPriceController.text = newDiscountStr;
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _basePriceController.dispose();
    _discountPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: 11,
    );
    final borderSide = BorderSide(color: Colors.grey.shade200);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: borderSide),
        color: widget.index.isEven ? Colors.white : Colors.grey.shade50,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // # (Row number)
            _cell(
              width: 50,
              child: Center(
                child: Text(
                  '${widget.index + 1}',
                  style: style?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),
            // Diseños (incluye imágenes y tallas)
            _cell(
              width: 220,
              child: _DesignsCell(
                row: widget.row,
                style: style,
                onTap: () => _openDesignsDialog(context),
              ),
            ),
            // ID
            _cell(
              width: 160,
              child: _buildTextField(
                controller: _idController,
                hint: 'PROD-001',
                style: style,
                readOnly: widget.isEditMode,
                onChanged: widget.onIdChanged,
              ),
            ),
            // Nombre
            _cell(
              width: 260,
              child: _buildTextField(
                controller: _nameController,
                hint: 'Nombre del producto',
                style: style,
                onChanged: widget.onNameChanged,
              ),
            ),
            // Descripción
            _cell(
              width: 400,
              child: _buildTextField(
                controller: _descriptionController,
                hint: 'Descripción del producto...',
                style: style,
                maxLines: 2,
                onChanged: widget.onDescriptionChanged,
              ),
            ),
            // Precio Base
            _cell(
              width: 140,
              child: _buildTextField(
                controller: _basePriceController,
                hint: '0.00',
                style: style,
                prefix: 'S/ ',
                isNumeric: true,
                onChanged: widget.onBasePriceChanged,
              ),
            ),
            // Precio Oferta
            _cell(
              width: 140,
              child: _buildTextField(
                controller: _discountPriceController,
                hint: '0.00',
                style: style,
                prefix: 'S/ ',
                isNumeric: true,
                onChanged: widget.onDiscountPriceChanged,
              ),
            ),
            // Categorías
            _cell(
              width: 220,
              child: InkWell(
                onTap: () => _openCategoriesDialog(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: widget.row.categoryIds.isEmpty
                      ? Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const Gap(4),
                                Text(
                                  'Añadir',
                                  style: style?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            ...widget.row.categoryIds.map(
                              (c) => Chip(
                                label: Text(c,
                                    style: style?.copyWith(fontSize: 10)),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 10,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            // Visible
            _cell(
              width: 90,
              child: Center(
                child: Switch(
                  value: widget.row.isVisible,
                  onChanged: widget.onVisibilityChanged,
                ),
              ),
            ),
            // Acciones (eliminar fila)
            _cell(
              width: 60,
              child: Center(
                child: widget.onRemove != null
                    ? IconButton(
                        onPressed: widget.onRemove,
                        icon: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.red.shade400,
                        ),
                        tooltip: 'Eliminar fila',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cell({required double width, required Widget child}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required TextStyle? style,
    bool readOnly = false,
    int maxLines = 1,
    String? prefix,
    bool isNumeric = false,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: TextFormField(
        controller: controller,
        style: style,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: isNumeric
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        inputFormatters: isNumeric
            ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))]
            : null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: style?.copyWith(color: Colors.grey.shade400),
          prefixText: prefix,
          prefixStyle: style,
          border: readOnly ? InputBorder.none : const OutlineInputBorder(),
          enabledBorder: readOnly
              ? InputBorder.none
              : OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          isDense: true,
          filled: readOnly,
          fillColor: readOnly ? Colors.grey.shade100 : null,
        ),
        onChanged: onChanged,
      ),
    );
  }

  void _openDesignsDialog(BuildContext context) {
    ProductDesignsDialog.show(
      context: context,
      productName: widget.row.name,
      initialDesigns: widget.row.designs,
      onSave: widget.onDesignsChanged,
    );
  }

  void _openCategoriesDialog(BuildContext context) {
    ProductCategoriesDialog.show(
      context: context,
      initialCategories: widget.row.categoryIds,
      onSave: widget.onCategoriesChanged,
    );
  }
}

class _DesignsCell extends StatelessWidget {
  final ProductBatchRowData row;
  final TextStyle? style;
  final VoidCallback onTap;

  const _DesignsCell({
    required this.row,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final allImages = row.allImages;
    final hasImages = allImages.isNotEmpty;
    final hasConfiguredSizes = row.hasDesigns;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            // Thumbnail / Icon
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 42,
                height: 42,
                color: Colors.grey.shade100,
                child: hasImages
                    ? _buildThumbnail(allImages.first)
                    : Icon(
                        Icons.style_outlined,
                        size: 20,
                        color: Colors.grey.shade400,
                      ),
              ),
            ),
            const Gap(8),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${row.totalDesigns} ${row.totalDesigns == 1 ? "diseño" : "diseños"}',
                          style: style?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasImages) ...[
                        const Gap(4),
                        Text(
                          '(${allImages.length} 📷)',
                          style: style?.copyWith(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Gap(2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: hasConfiguredSizes
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: hasConfiguredSizes
                            ? Colors.green.shade200
                            : Colors.orange.shade200,
                      ),
                    ),
                    child: Text(
                      hasConfiguredSizes
                          ? '${row.totalStock} uds total'
                          : 'Configurar tallas',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: hasConfiguredSizes
                            ? Colors.green.shade800
                            : Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
              ),
              child: Icon(
                Icons.edit,
                size: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BatchImageItem first) {
    if (first.isMemory && first.bytes != null) {
      return Image.memory(
        first.bytes!,
        fit: BoxFit.cover,
      );
    }
    if (first.isNetwork && first.url != null) {
      return Image.network(
        first.url!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          );
        },
        errorBuilder: (_, _, _) => Container(
          color: Colors.grey.shade200,
          child: Icon(Icons.broken_image,
              size: 16, color: Colors.grey.shade400),
        ),
      );
    }
    return Container(
      color: Colors.grey.shade200,
      child: Icon(Icons.image, size: 16, color: Colors.grey.shade400),
    );
  }
}
