import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';

enum ProductBatchMode { create, edit }

class BatchImageItem extends Equatable {
  final String? url;
  final Uint8List? bytes;
  final String? filename;

  const BatchImageItem.network(this.url)
      : bytes = null,
        filename = null;

  const BatchImageItem.memory({
    required this.bytes,
    required this.filename,
  }) : url = null;

  bool get isMemory => bytes != null;
  bool get isNetwork => url != null;

  @override
  List<Object?> get props => [url, bytes, filename];
}

class BatchDesignItem extends Equatable {
  final String id;
  final String name;
  final int? colorValue;
  final BatchImageItem? swatchImage;
  final List<BatchImageItem> images;
  final List<ProductSizeEntity> sizes;

  const BatchDesignItem({
    required this.id,
    required this.name,
    this.colorValue = 0xFF1B1B1B,
    this.swatchImage,
    this.images = const [],
    this.sizes = const [],
  });

  bool get hasSwatchImage => swatchImage != null;

  int get totalStock => sizes.fold(0, (sum, s) => sum + s.stock);

  bool get isValid => name.trim().isNotEmpty && sizes.isNotEmpty;

  BatchDesignItem copyWith({
    String? id,
    String? name,
    int? colorValue,
    bool clearColorValue = false,
    BatchImageItem? swatchImage,
    bool clearSwatchImage = false,
    List<BatchImageItem>? images,
    List<ProductSizeEntity>? sizes,
  }) {
    return BatchDesignItem(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: clearColorValue ? null : (colorValue ?? this.colorValue),
      swatchImage: clearSwatchImage ? null : (swatchImage ?? this.swatchImage),
      images: images ?? this.images,
      sizes: sizes ?? this.sizes,
    );
  }

  @override
  List<Object?> get props => [id, name, colorValue, swatchImage, images, sizes];
}

class ProductBatchRowData extends Equatable {
  final String tempId;
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final double? discountPrice;
  final List<String> categoryIds;
  final List<BatchDesignItem> designs;
  final bool isVisible;
  final ProductEntity? originalProduct;

  const ProductBatchRowData({
    required this.tempId,
    this.id = '',
    this.name = '',
    this.description = '',
    this.basePrice = 0.0,
    this.discountPrice,
    this.categoryIds = const [],
    this.designs = const [],
    this.isVisible = true,
    this.originalProduct,
  });

  factory ProductBatchRowData.empty(String tempId) {
    return ProductBatchRowData(
      tempId: tempId,
      designs: [
        BatchDesignItem(
          id: 'design_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Color único',
          colorValue: 0xFF1B1B1B,
          images: const [],
          sizes: const [],
        ),
      ],
    );
  }

  factory ProductBatchRowData.fromProduct(String tempId, ProductEntity product) {
    final designs = product.designs.map((d) {
      final swatch = d.swatchImageUrl != null && d.swatchImageUrl!.isNotEmpty
          ? BatchImageItem.network(d.swatchImageUrl!)
          : null;
      return BatchDesignItem(
        id: d.id,
        name: d.name,
        colorValue: swatch != null ? null : (d.colorValue ?? 0xFF1B1B1B),
        swatchImage: swatch,
        images: d.imageUrls.map((url) => BatchImageItem.network(url)).toList(),
        sizes: List.from(d.sizes),
      );
    }).toList();

    return ProductBatchRowData(
      tempId: tempId,
      id: product.id,
      name: product.name,
      description: product.description,
      basePrice: product.basePrice,
      discountPrice: product.discountPrice,
      categoryIds: List.from(product.categoryIds),
      designs: designs,
      isVisible: product.isVisible,
      originalProduct: product,
    );
  }

  List<BatchImageItem> get allImages =>
      designs.expand((d) => d.images).toList();

  List<BatchImageItem> get images => allImages;

  int get totalStock =>
      designs.fold(0, (sum, d) => sum + d.totalStock);

  int get totalDesigns => designs.length;

  bool get hasDesigns =>
      designs.isNotEmpty && designs.any((d) => d.sizes.isNotEmpty);

  bool get isValid {
    return id.trim().isNotEmpty &&
        name.trim().isNotEmpty &&
        basePrice > 0 &&
        designs.isNotEmpty &&
        designs.every((d) => d.name.trim().isNotEmpty && d.sizes.isNotEmpty);
  }

  ProductBatchRowData copyWith({
    String? tempId,
    String? id,
    String? name,
    String? description,
    double? basePrice,
    double? discountPrice,
    List<String>? categoryIds,
    List<BatchDesignItem>? designs,
    bool? isVisible,
    ProductEntity? originalProduct,
  }) {
    return ProductBatchRowData(
      tempId: tempId ?? this.tempId,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      discountPrice: discountPrice ?? this.discountPrice,
      categoryIds: categoryIds ?? this.categoryIds,
      designs: designs ?? this.designs,
      isVisible: isVisible ?? this.isVisible,
      originalProduct: originalProduct ?? this.originalProduct,
    );
  }

  @override
  List<Object?> get props => [
    tempId,
    id,
    name,
    description,
    basePrice,
    discountPrice,
    categoryIds,
    designs,
    isVisible,
    originalProduct,
  ];
}

class ProductBatchState extends Equatable {
  final ProductBatchMode mode;
  final List<ProductBatchRowData> rows;
  final bool isSubmitting;
  final String? errorMessage;
  final String? submitStatusMessage;

  const ProductBatchState({
    required this.mode,
    this.rows = const [],
    this.isSubmitting = false,
    this.errorMessage,
    this.submitStatusMessage,
  });

  bool get canSubmit {
    if (rows.isEmpty) return false;
    return rows.every((r) => r.isValid);
  }

  int get invalidRowCount {
    return rows.where((r) => !r.isValid).length;
  }

  ProductBatchState copyWith({
    ProductBatchMode? mode,
    List<ProductBatchRowData>? rows,
    bool? isSubmitting,
    String? errorMessage,
    String? submitStatusMessage,
  }) {
    return ProductBatchState(
      mode: mode ?? this.mode,
      rows: rows ?? this.rows,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      submitStatusMessage: submitStatusMessage ?? this.submitStatusMessage,
    );
  }

  @override
  List<Object?> get props => [mode, rows, isSubmitting, errorMessage, submitStatusMessage];
}
