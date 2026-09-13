import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/config/theme/app_theme.dart';
import 'package:marcos_malaga_app/app/core/utils/string_capitalize.dart';
import 'package:marcos_malaga_app/app/shared/widgets/image/custom_image.dart';
import 'package:marcos_malaga_app/app/shared/widgets/video/app_video_player.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/banners_provider.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/providers/features/catalog/catalog_providers.dart';

class BannerFormDialog extends ConsumerStatefulWidget {
  final BannerEntity? banner;

  const BannerFormDialog({super.key, this.banner});

  static Future<void> show(BuildContext context, {BannerEntity? banner}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BannerFormDialog(banner: banner),
    );
  }

  @override
  ConsumerState<BannerFormDialog> createState() => _BannerFormDialogState();
}

class _BannerFormDialogState extends ConsumerState<BannerFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _actionValueController;

  late BannerActionType _actionType;
  late bool _isActive;

  // Desktop media state
  late BannerMediaType _desktopMediaType;
  String _desktopUrl = '';
  Uint8List? _desktopNewBytes;
  String? _desktopNewFilename;

  // Mobile media state
  late BannerMediaType _mobileMediaType;
  String _mobileUrl = '';
  Uint8List? _mobileNewBytes;
  String? _mobileNewFilename;

  bool _isSaving = false;
  String _savingStatus = '';

  @override
  void initState() {
    super.initState();
    final b = widget.banner;
    _titleController = TextEditingController(text: b?.title ?? '');
    _actionValueController = TextEditingController(text: b?.actionValue ?? '');
    _desktopUrl = b?.desktopUrl ?? '';
    _mobileUrl = b?.mobileUrl ?? '';

    _actionType = b?.actionType ?? BannerActionType.none;
    _isActive = b?.isActive ?? true;

    _desktopMediaType = b?.desktopMediaType ?? BannerMediaType.image;
    _mobileMediaType = b?.mobileMediaType ?? BannerMediaType.image;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _actionValueController.dispose();
    super.dispose();
  }

  Future<void> _pickFile({required bool isDesktop}) async {
    final mediaType = isDesktop ? _desktopMediaType : _mobileMediaType;
    final isVideo = mediaType == BannerMediaType.video;

    final result = await FilePicker.platform.pickFiles(
      type: isVideo ? FileType.video : FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.bytes != null) {
        setState(() {
          if (isDesktop) {
            _desktopNewBytes = file.bytes;
            _desktopNewFilename = file.name;
          } else {
            _mobileNewBytes = file.bytes;
            _mobileNewFilename = file.name;
          }
        });
      }
    }
  }

  Future<void> _saveBanner() async {
    final hasDesktop = _desktopUrl.isNotEmpty || _desktopNewBytes != null;
    final hasMobile = _mobileUrl.isNotEmpty || _mobileNewBytes != null;

    final style = Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11);

    if (!hasDesktop) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debes seleccionar un medio para la versión de Escritorio (Desktop)', style: style?.copyWith(color: Colors.white)),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!hasMobile) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debes seleccionar un medio para la versión Móvil (Mobile)', style: style?.copyWith(color: Colors.white)),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
      _savingStatus = 'Preparando subida...';
    });

    try {
      final uploadUsecase = ref.read(uploadBannerMediaUsecaseProvider);
      String finalDesktopUrl = _desktopUrl;
      String finalMobileUrl = _mobileUrl;

      // Subir archivo Desktop si se seleccionó uno nuevo
      if (_desktopNewBytes != null) {
        setState(() => _savingStatus = 'Subiendo medio Desktop...');
        final isVideo = _desktopMediaType == BannerMediaType.video;
        final contentType = isVideo ? 'video/mp4' : 'image/jpeg';
        finalDesktopUrl = await uploadUsecase(
          bytes: _desktopNewBytes!,
          filename: 'desktop_${_desktopNewFilename ?? 'file'}',
          contentType: contentType,
        );
      }

      // Subir archivo Mobile si se seleccionó uno nuevo
      if (_mobileNewBytes != null) {
        setState(() => _savingStatus = 'Subiendo medio Mobile...');
        final isVideo = _mobileMediaType == BannerMediaType.video;
        final contentType = isVideo ? 'video/mp4' : 'image/jpeg';
        finalMobileUrl = await uploadUsecase(
          bytes: _mobileNewBytes!,
          filename: 'mobile_${_mobileNewFilename ?? 'file'}',
          contentType: contentType,
        );
      }

      setState(() => _savingStatus = 'Guardando banner...');
      final bannerId = widget.banner?.id ?? 'BANNER-${DateTime.now().millisecondsSinceEpoch}';

      final bannerEntity = BannerEntity(
        id: bannerId,
        title: _titleController.text.trim().isNotEmpty ? _titleController.text.trim() : null,
        desktopUrl: finalDesktopUrl,
        desktopMediaType: _desktopMediaType,
        mobileUrl: finalMobileUrl,
        mobileMediaType: _mobileMediaType,
        actionType: _actionType,
        actionValue: _actionType != BannerActionType.none && _actionValueController.text.trim().isNotEmpty
            ? _actionValueController.text.trim()
            : null,
        isActive: _isActive,
        index: widget.banner?.index ?? 0,
        createdAt: widget.banner?.createdAt,
      );

      final notifier = ref.read(bannersProvider.notifier);
      if (widget.banner != null) {
        await notifier.updateBanner(bannerEntity);
      } else {
        await notifier.createBanner(bannerEntity);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.banner != null ? 'Banner actualizado correctamente' : 'Banner creado correctamente',
              style: style?.copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar banner: $e', style: style?.copyWith(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = style?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    final isEditing = widget.banner != null;
    final productsAsync = ref.watch(productsProvider);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 850),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cabecera superior
                Row(
                  children: [
                    Icon(
                      isEditing ? Icons.edit : Icons.add_photo_alternate,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        isEditing ? 'EDITAR BANNER' : 'CREAR NUEVO BANNER',
                        style: titleStyle,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(),
                const Gap(12),

                // Contenido desplazable
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título del banner
                        TextFormField(
                          controller: _titleController,
                          style: style,
                          decoration: InputDecoration(
                            labelText: 'Título del Banner (opcional)',
                            labelStyle: style,
                            hintText: 'Ej. Colección Otoño 2026',
                            hintStyle: style?.copyWith(color: Colors.grey.shade400),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                        const Gap(16),

                        // Fila de Acción al hacer clic
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: DropdownButtonFormField<BannerActionType>(
                                key: ValueKey('action_type_$_actionType'),
                                initialValue: _actionType,
                                style: style,
                                decoration: InputDecoration(
                                  labelText: 'Acción al Clic',
                                  labelStyle: style,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: BannerActionType.none,
                                    child: Text('Sin acción (solo visual)', style: style),
                                  ),
                                  DropdownMenuItem(
                                    value: BannerActionType.openCategory,
                                    child: Text('Abrir Categoría', style: style),
                                  ),
                                  DropdownMenuItem(
                                    value: BannerActionType.openProduct,
                                    child: Text('Abrir Producto', style: style),
                                  ),
                                  DropdownMenuItem(
                                    value: BannerActionType.openUrl,
                                    child: Text('Abrir Enlace Web', style: style),
                                  ),
                                ],
                                onChanged: (type) {
                                  if (type != null) {
                                    setState(() {
                                      if (_actionType != type) {
                                        _actionType = type;
                                        _actionValueController.clear();
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                            if (_actionType != BannerActionType.none) ...[
                              const Gap(12),
                              Expanded(
                                flex: 5,
                                child: _buildActionValueField(style, productsAsync),
                              ),
                            ],
                          ],
                        ),
                        const Gap(16),

                        // Switch de visibilidad
                        SwitchListTile(
                          title: Text('Banner Activo en Tienda', style: style?.copyWith(fontWeight: FontWeight.bold)),
                          subtitle: Text('Si está desactivado, no se mostrará a los clientes', style: style?.copyWith(color: Colors.grey.shade600)),
                          value: _isActive,
                          onChanged: (val) => setState(() => _isActive = val),
                          activeThumbColor: AppTheme.primaryColor,
                          contentPadding: EdgeInsets.zero,
                        ),
                        const Gap(16),

                        const Divider(),
                        const Gap(12),

                        // SECCIONES DE MEDIOS (DESKTOP ARRIBA Y MOBILE ABAJO - APILADOS CON PROPORCIONES REALES)
                        _buildDesktopSlotCard(style, titleStyle),
                        const Gap(16),
                        _buildMobileSlotCard(style, titleStyle),
                      ],
                    ),
                  ),
                ),

                const Gap(16),
                const Divider(),
                const Gap(8),

                // Barra inferior de botones
                if (_isSaving) ...[
                  LinearProgressIndicator(color: AppTheme.primaryColor),
                  const Gap(8),
                  Text(_savingStatus, textAlign: TextAlign.center, style: style?.copyWith(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                  const Gap(12),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text('Cancelar', style: style),
                    ),
                    const Gap(12),
                    FilledButton.icon(
                      onPressed: _isSaving ? null : _saveBanner,
                      icon: const Icon(Icons.save, size: 16),
                      label: Text(
                        isEditing ? 'Guardar Cambios' : 'Crear Banner',
                        style: style?.copyWith(color: Colors.white),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionValueField(TextStyle? style, AsyncValue<List<ProductEntity>> productsAsync) {
    switch (_actionType) {
      case BannerActionType.openCategory:
        return productsAsync.when(
          loading: () => DropdownButtonFormField<String>(
            key: const ValueKey('category_dropdown_loading'),
            decoration: InputDecoration(
              labelText: 'Categoría o Colección',
              labelStyle: style,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            items: const [],
            onChanged: null,
            hint: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const Gap(8),
                Text('Cargando categorías...', style: style?.copyWith(color: Colors.grey.shade500)),
              ],
            ),
          ),
          error: (err, stack) => TextFormField(
            enabled: false,
            style: style,
            decoration: InputDecoration(
              labelText: 'Categoría o Colección',
              labelStyle: style,
              hintText: 'Error al cargar categorías: $err',
              hintStyle: style?.copyWith(color: Colors.red.shade400),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
          data: (products) {
            final Set<String> categoriesSet = {};
            for (final p in products) {
              categoriesSet.addAll(p.categoryIds);
            }
            final categories = categoriesSet.where((c) => c.trim().isNotEmpty).toList()..sort();
            final currentVal = _actionValueController.text.trim();

            // Si el banner ya tenía una categoría previa guardada que no está en los productos,
            // se incluye dinámicamente para que el DropdownButton no rompa la aserción de Flutter
            if (currentVal.isNotEmpty && !categories.contains(currentVal)) {
              categories.insert(0, currentVal);
            }

            final selectedCategory = currentVal.isNotEmpty && categories.contains(currentVal)
                ? currentVal
                : null;

            return DropdownButtonFormField<String>(
              key: ValueKey('cat_dropdown_${selectedCategory ?? 'none'}'),
              initialValue: selectedCategory,
              isExpanded: true,
              style: style,
              menuMaxHeight: 350,
              decoration: InputDecoration(
                labelText: 'Categoría o Colección',
                labelStyle: style,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              hint: Text(
                'Seleccionar categoría...',
                style: style?.copyWith(color: Colors.grey.shade500),
              ),
              items: categories.map((cat) {
                return DropdownMenuItem<String>(
                  value: cat,
                  child: Text(cat.capitalize(), style: style, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (cat) {
                if (cat != null) {
                  setState(() {
                    _actionValueController.text = cat;
                  });
                }
              },
            );
          },
        );

      case BannerActionType.openProduct:
        return productsAsync.when(
          loading: () => DropdownButtonFormField<String>(
            key: const ValueKey('product_dropdown_loading'),
            decoration: InputDecoration(
              labelText: 'Seleccionar Producto',
              labelStyle: style,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            items: const [],
            onChanged: null,
            hint: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const Gap(8),
                Text('Cargando productos...', style: style?.copyWith(color: Colors.grey.shade500)),
              ],
            ),
          ),
          error: (err, stack) => TextFormField(
            enabled: false,
            style: style,
            decoration: InputDecoration(
              labelText: 'Seleccionar Producto',
              labelStyle: style,
              hintText: 'Error al cargar productos: $err',
              hintStyle: style?.copyWith(color: Colors.red.shade400),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
          data: (products) {
            final currentVal = _actionValueController.text.trim();
            final hasCurrentProduct = products.any((p) => p.id == currentVal);

            final List<DropdownMenuItem<String>> items = [];

            // Si el banner ya tiene un ID de producto asignado que no está en la lista actual, incluirlo dinámicamente
            if (currentVal.isNotEmpty && !hasCurrentProduct) {
              items.add(
                DropdownMenuItem<String>(
                  value: currentVal,
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.inventory_2_outlined, size: 14, color: Colors.grey),
                      ),
                      const Gap(8),
                      Expanded(
                        child: Text('ID: $currentVal', style: style, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              );
            }

            final seenIds = <String>{};
            for (final p in products) {
              if (!seenIds.add(p.id)) continue;
              final firstImage = p.designs.expand((d) => d.imageUrls).firstOrNull ?? '';
              items.add(
                DropdownMenuItem<String>(
                  value: p.id,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: firstImage.isNotEmpty
                              ? CustomImage(
                                  firstImage,
                                  isAsset: firstImage.startsWith('assets/'),
                                  fit: BoxFit.cover,
                                  quality: ImageQuality.thumbnail,
                                )
                              : Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.image_not_supported, size: 14, color: Colors.grey),
                                ),
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          '${p.name} (${p.id})',
                          style: style,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final selectedProduct = currentVal.isNotEmpty ? currentVal : null;

            return DropdownButtonFormField<String>(
              key: ValueKey('prod_dropdown_${selectedProduct ?? 'none'}'),
              initialValue: selectedProduct,
              isExpanded: true,
              style: style,
              menuMaxHeight: 350,
              decoration: InputDecoration(
                labelText: 'Seleccionar Producto',
                labelStyle: style,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              hint: Text(
                'Seleccionar producto...',
                style: style?.copyWith(color: Colors.grey.shade500),
              ),
              items: items,
              onChanged: (prodId) {
                if (prodId != null) {
                  setState(() {
                    _actionValueController.text = prodId;
                  });
                }
              },
            );
          },
        );

      case BannerActionType.openUrl:
        return TextFormField(
          controller: _actionValueController,
          style: style,
          decoration: InputDecoration(
            labelText: 'URL Enlace Web',
            labelStyle: style,
            hintText: 'https://...',
            hintStyle: style?.copyWith(color: Colors.grey.shade400),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        );

      case BannerActionType.none:
        return const SizedBox.shrink();
    }
  }

  // Slot Desktop: Aspecto ancho horizontal
  Widget _buildDesktopSlotCard(TextStyle? style, TextStyle? titleStyle) {
    final isVideo = _desktopMediaType == BannerMediaType.video;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('VERSIÓN ESCRITORIO (DESKTOP)', style: titleStyle?.copyWith(fontSize: 12)),
                    const Gap(2),
                    Text('Aspecto panorámico / horizontal (recomendado 16:9 o 1920x800)', style: style?.copyWith(color: Colors.grey.shade600)),
                  ],
                ),
              ),
              SegmentedButton<BannerMediaType>(
                segments: const [
                  ButtonSegment(
                    value: BannerMediaType.image,
                    label: Text('Imagen'),
                    icon: Icon(Icons.image, size: 14),
                  ),
                  ButtonSegment(
                    value: BannerMediaType.video,
                    label: Text('Video MP4'),
                    icon: Icon(Icons.videocam, size: 14),
                  ),
                ],
                selected: {_desktopMediaType},
                onSelectionChanged: (set) {
                  setState(() {
                    _desktopMediaType = set.first;
                    _desktopNewBytes = null;
                    _desktopNewFilename = null;
                  });
                },
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
              ),
            ],
          ),
          const Gap(12),

          // Previsualización panorámica completa (16:7 aspect ratio horizontal)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 150,
              width: double.infinity,
              color: Colors.black12,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  if (_desktopNewBytes != null)
                    isVideo
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.video_file, size: 40, color: Colors.blue),
                              const Gap(4),
                              Text(
                                _desktopNewFilename ?? 'Video seleccionado',
                                style: style?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${(_desktopNewBytes!.lengthInBytes / (1024 * 1024)).toStringAsFixed(2)} MB',
                                style: style?.copyWith(color: Colors.grey.shade600),
                              ),
                            ],
                          )
                        : Image.memory(_desktopNewBytes!, fit: BoxFit.cover)
                  else if (_desktopUrl.isNotEmpty)
                    isVideo
                        ? AppVideoPlayer(videoUrl: _desktopUrl, fit: BoxFit.cover)
                        : CustomImage(
                            _desktopUrl,
                            isAsset: _desktopUrl.startsWith('assets/'),
                            fit: BoxFit.cover,
                          )
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(isVideo ? Icons.videocam_outlined : Icons.image_outlined, size: 40, color: Colors.grey.shade400),
                        const Gap(6),
                        Text('Sin medio configurado para Desktop', style: style?.copyWith(color: Colors.grey.shade500)),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const Gap(12),

          // Botón para seleccionar o cambiar archivo
          Row(
            children: [
              FilledButton.tonalIcon(
                onPressed: () => _pickFile(isDesktop: true),
                icon: const Icon(Icons.upload_file, size: 16),
                label: Text(
                  _desktopNewBytes != null || _desktopUrl.isNotEmpty
                      ? 'Cambiar medio Desktop'
                      : 'Seleccionar medio Desktop',
                  style: style,
                ),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              if (_desktopNewFilename != null) ...[
                const Gap(12),
                Expanded(
                  child: Text(
                    'Archivo seleccionado: $_desktopNewFilename',
                    style: style?.copyWith(color: Colors.teal, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // Slot Mobile: Layout horizontal con preview vertical teléfono (9:16) a la izquierda y controles a la derecha
  Widget _buildMobileSlotCard(TextStyle? style, TextStyle? titleStyle) {
    final isVideo = _mobileMediaType == BannerMediaType.video;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('VERSIÓN MÓVIL (MOBILE)', style: titleStyle?.copyWith(fontSize: 12)),
                    const Gap(2),
                    Text('Aspecto vertical alargado (recomendado 9:16 o 1080x1920)', style: style?.copyWith(color: Colors.grey.shade600)),
                  ],
                ),
              ),
              SegmentedButton<BannerMediaType>(
                segments: const [
                  ButtonSegment(
                    value: BannerMediaType.image,
                    label: Text('Imagen'),
                    icon: Icon(Icons.image, size: 14),
                  ),
                  ButtonSegment(
                    value: BannerMediaType.video,
                    label: Text('Video MP4'),
                    icon: Icon(Icons.videocam, size: 14),
                  ),
                ],
                selected: {_mobileMediaType},
                onSelectionChanged: (set) {
                  setState(() {
                    _mobileMediaType = set.first;
                    _mobileNewBytes = null;
                    _mobileNewFilename = null;
                  });
                },
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
              ),
            ],
          ),
          const Gap(12),

          // Fila con marco de teléfono vertical a la izquierda y controles a la derecha
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview Vertical con proporción de pantalla de smartphone (115 x 195 px)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 115,
                  height: 195,
                  color: Colors.black12,
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      if (_mobileNewBytes != null)
                        isVideo
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.video_file, size: 36, color: Colors.blue),
                                  const Gap(4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      _mobileNewFilename ?? 'Video',
                                      textAlign: TextAlign.center,
                                      style: style?.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '${(_mobileNewBytes!.lengthInBytes / (1024 * 1024)).toStringAsFixed(1)} MB',
                                    style: style?.copyWith(fontSize: 9, color: Colors.grey.shade600),
                                  ),
                                ],
                              )
                            : Image.memory(_mobileNewBytes!, fit: BoxFit.cover)
                      else if (_mobileUrl.isNotEmpty)
                        isVideo
                            ? AppVideoPlayer(videoUrl: _mobileUrl, fit: BoxFit.cover)
                            : CustomImage(
                                _mobileUrl,
                                isAsset: _mobileUrl.startsWith('assets/'),
                                fit: BoxFit.cover,
                              )
                      else
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(isVideo ? Icons.videocam_outlined : Icons.phone_android, size: 36, color: Colors.grey.shade400),
                            const Gap(6),
                            Text('Sin medio\nMóvil', textAlign: TextAlign.center, style: style?.copyWith(color: Colors.grey.shade500)),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const Gap(16),

              // Controles a la derecha del preview vertical
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () => _pickFile(isDesktop: false),
                      icon: const Icon(Icons.upload_file, size: 16),
                      label: Text(
                        _mobileNewBytes != null || _mobileUrl.isNotEmpty
                            ? 'Cambiar medio Móvil'
                            : 'Seleccionar medio Móvil',
                        style: style,
                      ),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    if (_mobileNewFilename != null) ...[
                      const Gap(8),
                      Text(
                        'Archivo seleccionado: $_mobileNewFilename',
                        style: style?.copyWith(color: Colors.teal, fontWeight: FontWeight.bold),
                      ),
                    ],
                    const Gap(16),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 14, color: Colors.blue.shade800),
                          const Gap(8),
                          Expanded(
                            child: Text(
                              'El banner móvil se mostrará automáticamente en smartphones sin deformar la versión de escritorio.',
                              style: style?.copyWith(color: Colors.blue.shade900, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
