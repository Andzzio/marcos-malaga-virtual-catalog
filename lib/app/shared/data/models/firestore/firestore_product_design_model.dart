import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_size_model.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';

class FirestoreProductDesignModel extends Equatable {
  final String id;
  final String name;
  final String hexCode;
  final List<String> imageUrls;
  final String? swatchImageUrl;
  final List<FirestoreProductSizeModel> sizes;

  const FirestoreProductDesignModel({
    required this.id,
    required this.name,
    required this.hexCode,
    required this.imageUrls,
    this.swatchImageUrl,
    required this.sizes,
  });

  factory FirestoreProductDesignModel.fromFirestore(Map<String, dynamic> json) {
    return FirestoreProductDesignModel(
      id: json['id'] as String,
      name: json['name'] as String,
      hexCode: json['hexCode'] as String? ?? '',
      imageUrls: List<String>.from(json['imageUrls'] as List? ?? []),
      swatchImageUrl: json['swatchImageUrl'] as String?,
      sizes: (json['sizes'] as List? ?? []).map((s) => FirestoreProductSizeModel.fromFirestore(s as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'hexCode': hexCode,
      'imageUrls': imageUrls,
      if (swatchImageUrl != null) 'swatchImageUrl': swatchImageUrl,
      'sizes': sizes.map((s) => s.toFirestore()).toList(),
    };
  }

  ProductDesignEntity toEntity() {
    int? colorValue;
    if (hexCode.isNotEmpty) {
      colorValue = int.tryParse(hexCode.replaceAll('#', ''), radix: 16);
    }
    return ProductDesignEntity(
      id: id,
      name: name,
      colorValue: colorValue,
      swatchImageUrl: swatchImageUrl,
      imageUrls: imageUrls,
      sizes: sizes.map((s) => s.toEntity()).toList(),
    );
  }

  factory FirestoreProductDesignModel.fromEntity(ProductDesignEntity entity) {
    return FirestoreProductDesignModel(
      id: entity.id,
      name: entity.name,
      hexCode: entity.colorValue != null ? entity.colorValue!.toRadixString(16).toUpperCase() : '',
      imageUrls: entity.imageUrls,
      swatchImageUrl: entity.swatchImageUrl,
      sizes: entity.sizes.map((s) => FirestoreProductSizeModel.fromEntity(s)).toList(),
    );
  }

  @override
  List<Object?> get props => [id, name, hexCode, imageUrls, swatchImageUrl, sizes];
}
