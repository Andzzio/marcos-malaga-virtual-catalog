import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';

class BannerModel {
  final String id;
  final String? title;
  final String desktopUrl;
  final String desktopMediaType;
  final String mobileUrl;
  final String mobileMediaType;
  final String actionType;
  final String? actionValue;
  final bool isActive;
  final int index;
  final String? createdAt;

  const BannerModel({
    required this.id,
    this.title,
    required this.desktopUrl,
    this.desktopMediaType = 'image',
    required this.mobileUrl,
    this.mobileMediaType = 'image',
    required this.actionType,
    this.actionValue,
    this.isActive = true,
    this.index = 0,
    this.createdAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    String? parsedCreatedAt;
    final rawCreatedAt = json['createdAt'];
    if (rawCreatedAt is String) {
      parsedCreatedAt = rawCreatedAt;
    } else if (rawCreatedAt != null && rawCreatedAt is! String) {
      try {
        parsedCreatedAt = (rawCreatedAt as dynamic).toDate().toIso8601String();
      } catch (_) {
        parsedCreatedAt = rawCreatedAt.toString();
      }
    }

    return BannerModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String?,
      desktopUrl: (json['desktopUrl'] ?? json['desktopImageUrl']) as String? ?? '',
      desktopMediaType: json['desktopMediaType'] as String? ?? 'image',
      mobileUrl: (json['mobileUrl'] ?? json['mobileImageUrl']) as String? ?? '',
      mobileMediaType: json['mobileMediaType'] as String? ?? 'image',
      actionType: json['actionType'] as String? ?? 'none',
      actionValue: json['actionValue'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      index: (json['index'] as num?)?.toInt() ?? 0,
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (title != null) 'title': title,
      'desktopUrl': desktopUrl,
      'desktopMediaType': desktopMediaType,
      'mobileUrl': mobileUrl,
      'mobileMediaType': mobileMediaType,
      'actionType': actionType,
      if (actionValue != null) 'actionValue': actionValue,
      'isActive': isActive,
      'index': index,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  BannerEntity toEntity() {
    return BannerEntity(
      id: id,
      title: title,
      desktopUrl: desktopUrl,
      desktopMediaType: _mapMediaType(desktopMediaType),
      mobileUrl: mobileUrl,
      mobileMediaType: _mapMediaType(mobileMediaType),
      actionType: _mapActionType(actionType),
      actionValue: actionValue,
      isActive: isActive,
      index: index,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }

  factory BannerModel.fromEntity(BannerEntity entity) {
    return BannerModel(
      id: entity.id,
      title: entity.title,
      desktopUrl: entity.desktopUrl,
      desktopMediaType: _unmapMediaType(entity.desktopMediaType),
      mobileUrl: entity.mobileUrl,
      mobileMediaType: _unmapMediaType(entity.mobileMediaType),
      actionType: _unmapActionType(entity.actionType),
      actionValue: entity.actionValue,
      isActive: entity.isActive,
      index: entity.index,
      createdAt: entity.createdAt?.toIso8601String(),
    );
  }

  BannerModel copyWith({
    String? id,
    String? title,
    String? desktopUrl,
    String? desktopMediaType,
    String? mobileUrl,
    String? mobileMediaType,
    String? actionType,
    String? actionValue,
    bool? isActive,
    int? index,
    String? createdAt,
  }) {
    return BannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      desktopUrl: desktopUrl ?? this.desktopUrl,
      desktopMediaType: desktopMediaType ?? this.desktopMediaType,
      mobileUrl: mobileUrl ?? this.mobileUrl,
      mobileMediaType: mobileMediaType ?? this.mobileMediaType,
      actionType: actionType ?? this.actionType,
      actionValue: actionValue ?? this.actionValue,
      isActive: isActive ?? this.isActive,
      index: index ?? this.index,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static BannerMediaType _mapMediaType(String? type) {
    if (type == 'video') return BannerMediaType.video;
    return BannerMediaType.image;
  }

  static String _unmapMediaType(BannerMediaType type) {
    switch (type) {
      case BannerMediaType.video:
        return 'video';
      case BannerMediaType.image:
        return 'image';
    }
  }

  static BannerActionType _mapActionType(String type) {
    switch (type) {
      case 'openCategory':
        return BannerActionType.openCategory;
      case 'openProduct':
        return BannerActionType.openProduct;
      case 'openUrl':
        return BannerActionType.openUrl;
      default:
        return BannerActionType.none;
    }
  }

  static String _unmapActionType(BannerActionType type) {
    switch (type) {
      case BannerActionType.openCategory:
        return 'openCategory';
      case BannerActionType.openProduct:
        return 'openProduct';
      case BannerActionType.openUrl:
        return 'openUrl';
      default:
        return 'none';
    }
  }
}
