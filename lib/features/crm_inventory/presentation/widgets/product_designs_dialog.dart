import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';
import 'package:marcos_malaga_app/app/shared/widgets/image/custom_image.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/product_batch_state.dart';
import 'color_picker_dialog.dart';

class ProductDesignsDialog extends StatefulWidget {
  final String productName;
  final List<BatchDesignItem> initialDesigns;
  final ValueChanged<List<BatchDesignItem>> onSave;

  const ProductDesignsDialog({
    super.key,
    required this.productName,
    required this.initialDesigns,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    required String productName,
    required List<BatchDesignItem> initialDesigns,
    required ValueChanged<List<BatchDesignItem>> onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProductDesignsDialog(
        productName: productName,
        initialDesigns: initialDesigns,
        onSave: onSave,
      ),
    );
  }

  @override
  State<ProductDesignsDialog> createState() => _ProductDesignsDialogState();
}

class _ProductDesignsDialogState extends State<ProductDesignsDialog> {
  late List<BatchDesignItem> _designs;
  final ScrollController _horizontalScrollController = ScrollController();
  static const List<String> _quickSizes = ['S', 'M', 'L', 'XL', 'ESTÁNDAR', 'ÚNICA'];

  @override
  void initState() {
    super.initState();
    if (widget.initialDesigns.isEmpty) {
      _designs = [
        BatchDesignItem(
          id: 'design_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Color único',
          images: const [],
          sizes: const [
            ProductSizeEntity(size: 'S', stock: 0),
            ProductSizeEntity(size: 'M', stock: 0),
            ProductSizeEntity(size: 'L', stock: 0),
          ],
        ),
      ];
    } else {
      _designs = widget.initialDesigns
          .map((d) => d.copyWith(
                sizes: List.from(d.sizes),
                images: List.from(d.images),
              ))
          .toList();
    }
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _addDesign() {
    setState(() {
      // If previous designs exist, pre-fill with the same size labels for convenience
      List<ProductSizeEntity> initialSizes = const [];
      if (_designs.isNotEmpty && _designs.last.sizes.isNotEmpty) {
        initialSizes = _designs.last.sizes
            .map((s) => ProductSizeEntity(size: s.size, stock: 0))
            .toList();
      }

      _designs.add(
        BatchDesignItem(
          id: 'design_${DateTime.now().microsecondsSinceEpoch}',
          name: 'Diseño ${_designs.length + 1}',
          images: const [],
          sizes: initialSizes,
        ),
      );
    });

    // Scroll to end
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_horizontalScrollController.hasClients) {
        _horizontalScrollController.animateTo(
          _horizontalScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _removeDesign(int index) {
    if (_designs.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe existir al menos un diseño para el producto'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() {
      _designs.removeAt(index);
    });
  }

  void _moveDesign(int fromIndex, int toIndex) {
    if (toIndex < 0 || toIndex >= _designs.length) return;
    setState(() {
      final item = _designs.removeAt(fromIndex);
      _designs.insert(toIndex, item);
    });
  }

  Future<void> _pickImagesForDesign(int designIndex) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final newImages = <BatchImageItem>[];
    for (final file in result.files) {
      if (file.bytes != null) {
        newImages.add(
          BatchImageItem.memory(
            bytes: file.bytes!,
            filename: file.name,
          ),
        );
      }
    }

    if (newImages.isNotEmpty) {
      setState(() {
        final current = _designs[designIndex];
        _designs[designIndex] = current.copyWith(
          images: [...current.images, ...newImages],
        );
      });
    }
  }

  void _removeImage(int designIndex, int imageIndex) {
    setState(() {
      final current = _designs[designIndex];
      final updated = List<BatchImageItem>.from(current.images)..removeAt(imageIndex);
      _designs[designIndex] = current.copyWith(images: updated);
    });
  }

  Future<void> _pickSwatchImageForDesign(int designIndex) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;

    final swatchItem = BatchImageItem.memory(
      bytes: file.bytes!,
      filename: file.name,
    );

    setState(() {
      final current = _designs[designIndex];
      _designs[designIndex] = current.copyWith(
        swatchImage: swatchItem,
        clearColorValue: true,
      );
    });
  }

  void _useFirstImageAsSwatch(int designIndex) {
    final current = _designs[designIndex];
    if (current.images.isEmpty) return;
    setState(() {
      _designs[designIndex] = current.copyWith(
        swatchImage: current.images.first,
        clearColorValue: true,
      );
    });
  }

  void _removeSwatchImage(int designIndex) {
    setState(() {
      final current = _designs[designIndex];
      _designs[designIndex] = current.copyWith(
        clearSwatchImage: true,
        colorValue: current.colorValue ?? 0xFF1B1B1B,
      );
    });
  }

  Future<void> _pickColorForDesign(int designIndex) async {
    final current = _designs[designIndex];
    final selectedColor = await ColorPickerDialog.show(
      context: context,
      initialColorValue: current.colorValue ?? 0xFF1B1B1B,
    );

    if (selectedColor != null) {
      setState(() {
        _designs[designIndex] = current.copyWith(
          colorValue: selectedColor,
          clearSwatchImage: true,
        );
      });
    }
  }

  void _toggleSwatchType(int designIndex, bool useImage) {
    final current = _designs[designIndex];
    if (useImage) {
      if (current.images.isNotEmpty) {
        setState(() {
          _designs[designIndex] = current.copyWith(
            swatchImage: current.images.first,
            clearColorValue: true,
          );
        });
      } else {
        _pickSwatchImageForDesign(designIndex);
      }
    } else {
      setState(() {
        _designs[designIndex] = current.copyWith(
          clearSwatchImage: true,
          colorValue: current.colorValue ?? 0xFF1B1B1B,
        );
      });
    }
  }

  void _addSizeToDesign(int designIndex, String sizeName, [int defaultStock = 0]) {
    final design = _designs[designIndex];
    if (design.sizes.any((s) => s.size.toLowerCase() == sizeName.trim().toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La talla "$sizeName" ya está agregada en este diseño')),
      );
      return;
    }

    setState(() {
      final updatedSizes = [
        ...design.sizes,
        ProductSizeEntity(size: sizeName.trim(), stock: defaultStock),
      ];
      _designs[designIndex] = design.copyWith(sizes: updatedSizes);
    });
  }

  void _updateSizeStock(int designIndex, int sizeIndex, int newStock) {
    setState(() {
      final design = _designs[designIndex];
      final updatedSizes = List<ProductSizeEntity>.from(design.sizes);
      updatedSizes[sizeIndex] = updatedSizes[sizeIndex].copyWith(stock: newStock.clamp(0, 99999));
      _designs[designIndex] = design.copyWith(sizes: updatedSizes);
    });
  }

  void _removeSize(int designIndex, int sizeIndex) {
    setState(() {
      final design = _designs[designIndex];
      final updatedSizes = List<ProductSizeEntity>.from(design.sizes)..removeAt(sizeIndex);
      _designs[designIndex] = design.copyWith(sizes: updatedSizes);
    });
  }

  void _promptCustomSize(int designIndex) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Agregar talla personalizada'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nombre de la talla',
            hintText: 'ej. 28, 30, 32, XXL...',
          ),
          onSubmitted: (val) {
            if (val.trim().isNotEmpty) {
              Navigator.of(ctx).pop();
              _addSizeToDesign(designIndex, val.trim());
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.of(ctx).pop();
                _addSizeToDesign(designIndex, controller.text.trim());
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _copySizesFromPrevious(int designIndex) {
    if (designIndex <= 0) return;
    final prevSizes = _designs[designIndex - 1].sizes;
    setState(() {
      final updatedSizes = prevSizes
          .map((s) => ProductSizeEntity(size: s.size, stock: s.stock))
          .toList();
      _designs[designIndex] = _designs[designIndex].copyWith(sizes: updatedSizes);
    });
  }

  int get _totalStockAllDesigns =>
      _designs.fold(0, (sum, d) => sum + d.totalStock);

  void _handleSave() {
    // Validate each design
    for (int i = 0; i < _designs.length; i++) {
      final d = _designs[i];
      if (d.name.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('El diseño #${i + 1} debe tener un nombre o color'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (d.sizes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('El diseño "${d.name}" debe tener al menos una talla configurada'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    widget.onSave(_designs);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: (size.width * 0.90).clamp(700.0, 1300.0),
        height: (size.height * 0.88).clamp(550.0, 850.0),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.style_outlined,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Variantes, Fotos y Tallas',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.productName.isNotEmpty
                            ? widget.productName
                            : 'Nuevo Producto',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Summary Badges
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    '${_designs.length} ${_designs.length == 1 ? "diseño" : "diseños"}  ·  $_totalStockAllDesigns uds en total',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
                const Gap(8),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Cerrar sin guardar',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Gap(16),
            const Divider(height: 1),
            const Gap(16),

            // Horizontal Scroll area with Design Cards
            Expanded(
              child: Scrollbar(
                controller: _horizontalScrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < _designs.length; i++) ...[
                        _buildDesignCard(i),
                        const Gap(16),
                      ],
                      _buildAddDesignCard(),
                    ],
                  ),
                ),
              ),
            ),

            const Gap(16),
            const Divider(height: 1),
            const Gap(16),

            // Footer
            Row(
              children: [
                Text(
                  'Desplaza horizontalmente para ver o reordenar los diseños con [←] [→]',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const Gap(12),
                FilledButton.icon(
                  onPressed: _handleSave,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Guardar Variantes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesignCard(int index) {
    final design = _designs[index];
    final theme = Theme.of(context);

    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card Header with Reordering
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '#${index + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    design.name.isNotEmpty ? design.name : 'Diseño ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 18),
                  tooltip: 'Mover a la izquierda',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  onPressed: index > 0 ? () => _moveDesign(index, index - 1) : null,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  tooltip: 'Mover a la derecha',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  onPressed: index < _designs.length - 1
                      ? () => _moveDesign(index, index + 1)
                      : null,
                ),
                const Gap(4),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade400),
                  tooltip: 'Eliminar este diseño',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  onPressed: _designs.length > 1 ? () => _removeDesign(index) : null,
                ),
              ],
            ),
          ),

          // Scrollable Card Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Nombre / Color
                  Text(
                    'COLOR / NOMBRE DEL DISEÑO',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Gap(6),
                  TextFormField(
                    initialValue: design.name,
                    decoration: InputDecoration(
                      hintText: 'ej. Negro, Rosa Palo, Estampado',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (val) {
                      _designs[index] = design.copyWith(name: val);
                    },
                  ),

                  const Gap(16),

                  // Muestra de color o foto
                  _buildColorOrSwatchSection(index),

                  const Gap(16),

                  // 2. Imágenes del diseño
                  Row(
                    children: [
                      Text(
                        'FOTOS DEL DISEÑO (${design.images.length})',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => _pickImagesForDesign(index),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Row(
                            children: [
                              Icon(Icons.add_photo_alternate_outlined,
                                  size: 14, color: theme.colorScheme.primary),
                              const Gap(4),
                              Text(
                                '+ Fotos',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),

                  // Gallery of images
                  if (design.images.isEmpty)
                    InkWell(
                      onTap: () => _pickImagesForDesign(index),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade50,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.camera_alt_outlined,
                                  size: 18, color: Colors.grey.shade500),
                              const Gap(8),
                              Text(
                                'Añadir fotos',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (int imgIdx = 0; imgIdx < design.images.length; imgIdx++)
                          _buildImageThumbnail(index, imgIdx, design.images[imgIdx]),
                        InkWell(
                          onTap: () => _pickImagesForDesign(index),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade50,
                            ),
                            child: Icon(Icons.add, color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),

                  const Gap(16),
                  const Divider(height: 1),
                  const Gap(16),

                  // 3. Tallas y Stock
                  Row(
                    children: [
                      Text(
                        'TALLAS Y STOCK',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: design.totalStock > 0
                              ? Colors.green.shade50
                              : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: design.totalStock > 0
                                ? Colors.green.shade300
                                : Colors.orange.shade300,
                          ),
                        ),
                        child: Text(
                          '${design.totalStock} uds',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: design.totalStock > 0
                                ? Colors.green.shade800
                                : Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),

                  // Configured sizes list
                  if (design.sizes.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'No hay tallas agregadas. Usa los atajos de abajo.',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    )
                  else
                    Column(
                      children: [
                        for (int sIdx = 0; sIdx < design.sizes.length; sIdx++)
                          _buildSizeRow(index, sIdx, design.sizes[sIdx]),
                      ],
                    ),

                  const Gap(8),

                  // Quick sizes buttons
                  Text(
                    'Atajos de talla rápida:',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const Gap(4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final qs in _quickSizes)
                        if (!design.sizes.any((s) => s.size.toUpperCase() == qs))
                          ActionChip(
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            label: Text('+ $qs', style: const TextStyle(fontSize: 11)),
                            onPressed: () => _addSizeToDesign(index, qs, 5),
                          ),
                      ActionChip(
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        avatar: const Icon(Icons.add, size: 12),
                        label: const Text('Otra', style: TextStyle(fontSize: 11)),
                        onPressed: () => _promptCustomSize(index),
                      ),
                    ],
                  ),

                  // Option to copy sizes from previous design
                  if (index > 0 && _designs[index - 1].sizes.isNotEmpty) ...[
                    const Gap(8),
                    TextButton.icon(
                      onPressed: () => _copySizesFromPrevious(index),
                      icon: const Icon(Icons.copy, size: 14),
                      label: const Text(
                        'Copiar tallas del diseño anterior',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOrSwatchSection(int index) {
    final design = _designs[index];
    final theme = Theme.of(context);
    final isImageMode = design.hasSwatchImage;
    final color = Color(design.colorValue ?? 0xFF1B1B1B);
    final isLightColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'MUESTRA / CÍRCULO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Text(
                'Foto / Patrón',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isImageMode ? FontWeight.bold : FontWeight.normal,
                  color: isImageMode
                      ? theme.colorScheme.primary
                      : Colors.grey.shade600,
                ),
              ),
              const Gap(4),
              SizedBox(
                height: 24,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Switch(
                    value: isImageMode,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (val) => _toggleSwatchType(index, val),
                  ),
                ),
              ),
            ],
          ),
          const Gap(10),
          if (!isImageMode) ...[
            Row(
              children: [
                GestureDetector(
                  onTap: () => _pickColorForDesign(index),
                  child: Tooltip(
                    message: 'Cambiar color',
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isLightColor
                              ? Colors.grey.shade400
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.colorize,
                          size: 16,
                          color: isLightColor ? Colors.black54 : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Color Sólido',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '#${(design.colorValue ?? 0xFF1B1B1B).toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  icon: const Icon(Icons.palette_outlined, size: 14),
                  label: const Text('Elegir', style: TextStyle(fontSize: 11)),
                  onPressed: () => _pickColorForDesign(index),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                GestureDetector(
                  onTap: () => _pickSwatchImageForDesign(index),
                  child: Tooltip(
                    message: 'Cambiar foto de muestra',
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: design.swatchImage != null
                            ? (design.swatchImage!.isMemory &&
                                    design.swatchImage!.bytes != null
                                ? Image.memory(
                                    design.swatchImage!.bytes!,
                                    width: 36,
                                    height: 36,
                                    fit: BoxFit.cover,
                                  )
                                : (design.swatchImage!.isNetwork &&
                                        design.swatchImage!.url != null
                                    ? CustomImage(
                                        design.swatchImage!.url!,
                                        width: 36,
                                        height: 36,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.image, size: 18)))
                            : Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.add_photo_alternate,
                                    size: 16, color: Colors.grey),
                              ),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Foto de muestra',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        design.swatchImage?.filename ??
                            (design.swatchImage?.url != null
                                ? 'Imagen en la nube'
                                : 'Sin foto seleccionada'),
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  icon: const Icon(Icons.file_upload_outlined, size: 14),
                  label: const Text('Subir', style: TextStyle(fontSize: 11)),
                  onPressed: () => _pickSwatchImageForDesign(index),
                ),
                if (design.images.isNotEmpty) ...[
                  const Gap(4),
                  IconButton(
                    tooltip: 'Usar la 1ª foto del diseño',
                    icon: const Icon(Icons.photo_library_outlined, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                    onPressed: () => _useFirstImageAsSwatch(index),
                  ),
                ],
                if (design.hasSwatchImage) ...[
                  const Gap(4),
                  IconButton(
                    tooltip: 'Quitar foto y volver a color plano',
                    icon: Icon(Icons.close, size: 16, color: Colors.grey.shade600),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                    onPressed: () => _removeSwatchImage(index),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageThumbnail(int designIndex, int imgIndex, BatchImageItem img) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 60,
            height: 60,
            color: Colors.grey.shade100,
            child: img.isMemory && img.bytes != null
                ? Image.memory(
                    img.bytes!,
                    fit: BoxFit.cover,
                  )
                : (img.isNetwork && img.url != null
                    ? Image.network(
                        img.url!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(Icons.broken_image, size: 20),
                      )
                    : const Icon(Icons.image, size: 20)),
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: InkWell(
            onTap: () => _removeImage(designIndex, imgIndex),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeRow(int designIndex, int sizeIndex, ProductSizeEntity sizeEntity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                sizeEntity.size,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const Spacer(),
            // Minus button
            IconButton(
              icon: const Icon(Icons.remove, size: 14),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
              onPressed: () => _updateSizeStock(
                designIndex,
                sizeIndex,
                sizeEntity.stock - 1,
              ),
            ),
            // Stock counter / input
            SizedBox(
              width: 50,
              child: TextFormField(
                key: ValueKey('stock_${designIndex}_${sizeIndex}_${sizeEntity.stock}'),
                initialValue: sizeEntity.stock.toString(),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onChanged: (val) {
                  final parsed = int.tryParse(val) ?? 0;
                  _updateSizeStock(designIndex, sizeIndex, parsed);
                },
              ),
            ),
            // Plus button
            IconButton(
              icon: const Icon(Icons.add, size: 14),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
              onPressed: () => _updateSizeStock(
                designIndex,
                sizeIndex,
                sizeEntity.stock + 1,
              ),
            ),
            const Gap(4),
            // Delete size button
            IconButton(
              icon: Icon(Icons.close, size: 16, color: Colors.grey.shade500),
              tooltip: 'Quitar talla',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              onPressed: () => _removeSize(designIndex, sizeIndex),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddDesignCard() {
    final theme = Theme.of(context);

    return InkWell(
      onTap: _addDesign,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 260,
        height: 480,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.4),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const Gap(12),
              Text(
                '+ Añadir otro diseño',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: theme.colorScheme.primary,
                ),
              ),
              const Gap(4),
              Text(
                'Color o variante adicional',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
