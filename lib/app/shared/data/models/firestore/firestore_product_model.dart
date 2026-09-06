import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_design_model.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';

class FirestoreProductModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final double? discountPrice;
  final List<String> categoryIds;
  final List<FirestoreProductDesignModel> designs;
  final bool isVisible;
  final String? sizeChartImageUrl;
  final Timestamp createdAt;
  final Timestamp? deletedAt;

  const FirestoreProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    this.discountPrice,
    required this.categoryIds,
    required this.designs,
    required this.isVisible,
    this.sizeChartImageUrl,
    required this.createdAt,
    this.deletedAt,
  });

  factory FirestoreProductModel.fromFirestore(Map<String, dynamic> json) {
    return FirestoreProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      basePrice: (json['basePrice'] as num).toDouble(),
      discountPrice: json['discountPrice'] != null
          ? (json['discountPrice'] as num).toDouble()
          : null,
      categoryIds: List<String>.from(json['categoryIds'] as List? ?? []),
      designs: (json['designs'] as List? ?? [])
          .map(
            (d) => FirestoreProductDesignModel.fromFirestore(
              d as Map<String, dynamic>,
            ),
          )
          .toList(),
      isVisible: json['isVisible'] as bool,
      sizeChartImageUrl: json['sizeChartImageUrl'] as String?,
      createdAt: json['createdAt'] as Timestamp,
      deletedAt: json['deletedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'basePrice': basePrice,
      if (discountPrice != null) 'discountPrice': discountPrice,
      'categoryIds': categoryIds,
      'designs': designs.map((d) => d.toFirestore()).toList(),
      'isVisible': isVisible,
      if (sizeChartImageUrl != null) 'sizeChartImageUrl': sizeChartImageUrl,
      'createdAt': createdAt,
      if (deletedAt != null) 'deletedAt': deletedAt,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      basePrice: basePrice,
      discountPrice: discountPrice,
      categoryIds: categoryIds,
      designs: designs.map((d) => d.toEntity()).toList(),
      isVisible: isVisible,
      sizeChartImageUrl: sizeChartImageUrl,
      createdAt: createdAt.toDate(),
      deletedAt: deletedAt?.toDate(),
    );
  }

  factory FirestoreProductModel.fromEntity(ProductEntity entity) {
    return FirestoreProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      basePrice: entity.basePrice,
      discountPrice: entity.discountPrice,
      categoryIds: entity.categoryIds,
      designs: entity.designs
          .map((d) => FirestoreProductDesignModel.fromEntity(d))
          .toList(),
      isVisible: entity.isVisible,
      sizeChartImageUrl: entity.sizeChartImageUrl,
      createdAt: Timestamp.fromDate(entity.createdAt),
      deletedAt: entity.deletedAt != null
          ? Timestamp.fromDate(entity.deletedAt!)
          : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    basePrice,
    discountPrice,
    categoryIds,
    designs,
    isVisible,
    sizeChartImageUrl,
    createdAt,
    deletedAt,
  ];
}
