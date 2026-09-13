import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/product_batch_state.dart';
import 'package:marcos_malaga_app/providers/core/core_providers.dart';

class ProductBatchProvider extends Notifier<ProductBatchState> {
  int _nextTempId = 0;

  String _generateCreateTempId() {
    _nextTempId++;
    return 'create_${DateTime.now().microsecondsSinceEpoch}_$_nextTempId';
  }

  @override
  ProductBatchState build() {
    return const ProductBatchState(mode: ProductBatchMode.create);
  }

  void initCreate([List<ProductEntity> initialProducts = const []]) {
    _nextTempId = 0;
    if (initialProducts.isEmpty) {
      state = ProductBatchState(
        mode: ProductBatchMode.create,
        rows: [ProductBatchRowData.empty(_generateCreateTempId())],
      );
    } else {
      state = ProductBatchState(
        mode: ProductBatchMode.create,
        rows: initialProducts
            .map((p) => ProductBatchRowData.fromProduct(_generateCreateTempId(), p))
            .toList(),
      );
    }
  }

  void initEdit(List<ProductEntity> products) {
    _nextTempId = 0;
    state = ProductBatchState(
      mode: ProductBatchMode.edit,
      rows: products
          .map((p) => ProductBatchRowData.fromProduct('edit_${p.id}', p))
          .toList(),
    );
  }

  void addRow() {
    if (state.mode != ProductBatchMode.create) return;
    state = state.copyWith(
      rows: [...state.rows, ProductBatchRowData.empty(_generateCreateTempId())],
    );
  }

  void removeRow(String tempId) {
    if (state.mode != ProductBatchMode.create) return;
    if (state.rows.length <= 1) return;
    state = state.copyWith(
      rows: state.rows.where((r) => r.tempId != tempId).toList(),
    );
  }

  void updateRowId(String tempId, String value) {
    _updateRow(tempId, (row) => row.copyWith(id: value));
  }

  void updateRowName(String tempId, String value) {
    _updateRow(tempId, (row) => row.copyWith(name: value));
  }

  void updateRowDescription(String tempId, String value) {
    _updateRow(tempId, (row) => row.copyWith(description: value));
  }

  void updateRowBasePrice(String tempId, String value) {
    final parsed = double.tryParse(value) ?? 0.0;
    _updateRow(tempId, (row) => row.copyWith(basePrice: parsed));
  }

  void updateRowDiscountPrice(String tempId, String value) {
    final parsed = value.isEmpty ? null : double.tryParse(value);
    _updateRow(tempId, (row) => row.copyWith(discountPrice: parsed ?? 0.0));
  }

  void updateRowVisibility(String tempId, bool value) {
    _updateRow(tempId, (row) => row.copyWith(isVisible: value));
  }

  void updateRowDesigns(String tempId, List<BatchDesignItem> designs) {
    _updateRow(tempId, (row) => row.copyWith(designs: designs));
  }

  void updateRowImages(String tempId, List<BatchImageItem> images) {
    _updateRow(tempId, (row) {
      if (row.designs.isEmpty) {
        return row.copyWith(designs: [
          BatchDesignItem(
            id: 'design_${DateTime.now().millisecondsSinceEpoch}',
            name: 'Color único',
            images: images,
            sizes: const [],
          ),
        ]);
      }
      final updatedDesigns = [
        row.designs.first.copyWith(images: images),
        ...row.designs.skip(1),
      ];
      return row.copyWith(designs: updatedDesigns);
    });
  }

  void updateRowCategories(String tempId, List<String> categoryIds) {
    _updateRow(tempId, (row) => row.copyWith(categoryIds: categoryIds));
  }

  Future<String> uploadImage({
    required Uint8List bytes,
    required String filename,
  }) async {
    final usecase = ref.read(uploadProductImageUsecaseProvider);
    return await usecase(bytes: bytes, filename: filename);
  }

  void _updateRow(
    String tempId,
    ProductBatchRowData Function(ProductBatchRowData) updater,
  ) {
    state = state.copyWith(
      rows: state.rows.map((r) {
        if (r.tempId == tempId) return updater(r);
        return r;
      }).toList(),
      errorMessage: null,
    );
  }

  Future<bool> submit() async {
    if (!state.canSubmit) return false;

    state = state.copyWith(
      isSubmitting: true,
      errorMessage: null,
      submitStatusMessage: 'Preparando imágenes...',
    );

    try {
      final provider = ref.read(productsProvider.notifier);

      final totalToUpload = state.rows.fold<int>(
        0,
        (sum, row) =>
            sum +
            row.designs.fold<int>(
              0,
              (dSum, d) =>
                  dSum +
                  d.images.where((img) => img.isMemory).length +
                  (d.swatchImage != null && d.swatchImage!.isMemory ? 1 : 0),
            ),
      );
      int uploadedCount = 0;

      final List<ProductEntity> entities = [];

      for (final row in state.rows) {
        final List<ProductDesignEntity> resolvedDesigns = [];

        for (final design in row.designs) {
          final List<String> resolvedUrls = [];
          for (final img in design.images) {
            if (img.isNetwork && img.url != null) {
              resolvedUrls.add(img.url!);
            } else if (img.isMemory && img.bytes != null) {
              uploadedCount++;
              state = state.copyWith(
                submitStatusMessage:
                    'Subiendo imagen $uploadedCount de $totalToUpload...',
              );
              final downloadUrl = await uploadImage(
                bytes: img.bytes!,
                filename: img.filename ??
                    'product_${DateTime.now().millisecondsSinceEpoch}.webp',
              );
              resolvedUrls.add(downloadUrl);
            }
          }

          String? resolvedSwatchUrl;
          if (design.swatchImage != null) {
            if (design.swatchImage!.isNetwork && design.swatchImage!.url != null) {
              resolvedSwatchUrl = design.swatchImage!.url;
            } else if (design.swatchImage!.isMemory &&
                design.swatchImage!.bytes != null) {
              uploadedCount++;
              state = state.copyWith(
                submitStatusMessage:
                    'Subiendo muestra $uploadedCount de $totalToUpload...',
              );
              resolvedSwatchUrl = await uploadImage(
                bytes: design.swatchImage!.bytes!,
                filename: design.swatchImage!.filename ??
                    'swatch_${DateTime.now().millisecondsSinceEpoch}.webp',
              );
            }
          }

          resolvedDesigns.add(
            ProductDesignEntity(
              id: design.id,
              name: design.name,
              colorValue: resolvedSwatchUrl != null
                  ? null
                  : (design.colorValue ?? 0xFF1B1B1B),
              swatchImageUrl: resolvedSwatchUrl,
              imageUrls: resolvedUrls,
              sizes: design.sizes,
            ),
          );
        }

        final original = row.originalProduct;
        entities.add(
          ProductEntity(
            id: row.id,
            name: row.name,
            description: row.description,
            basePrice: row.basePrice,
            discountPrice: row.discountPrice,
            categoryIds: row.categoryIds,
            designs: resolvedDesigns,
            isVisible: row.isVisible,
            sizeChartImageUrl: original?.sizeChartImageUrl,
            createdAt: state.mode == ProductBatchMode.create
                ? DateTime.now()
                : (original?.createdAt ?? DateTime.now()),
            deletedAt: state.mode == ProductBatchMode.create
                ? null
                : original?.deletedAt,
          ),
        );
      }

      state = state.copyWith(
        submitStatusMessage: 'Guardando en la base de datos...',
      );

      if (state.mode == ProductBatchMode.create) {
        await provider.createMany(entities);
      } else {
        for (final product in entities) {
          await provider.updateProduct(product);
        }
      }

      state = state.copyWith(isSubmitting: false, submitStatusMessage: null);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        submitStatusMessage: null,
        errorMessage: 'Error: $e',
      );
      return false;
    }
  }
}

final productBatchProvider =
    NotifierProvider<ProductBatchProvider, ProductBatchState>(
      ProductBatchProvider.new,
    );
