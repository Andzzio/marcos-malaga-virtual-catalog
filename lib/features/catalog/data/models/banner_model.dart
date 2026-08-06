import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';

class BannerModel {
  final String id;
  final String desktopImageUrl;
  final String mobileImageUrl;
  final String? title;
  final String actionType;
  final String? actionValue;
  final bool isActive;

  const BannerModel({
    required this.id,
    required this.desktopImageUrl,
    required this.mobileImageUrl,
    this.title,
    required this.actionType,
    this.actionValue,
    required this.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      desktopImageUrl: json['desktopImageUrl'] as String,
      mobileImageUrl: json['mobileImageUrl'] as String,
      title: json['title'] as String?,
      actionType: json['actionType'] as String,
      actionValue: json['actionValue'] as String?,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'desktopImageUrl': desktopImageUrl,
      'mobileImageUrl': mobileImageUrl,
      'title': title,
      'actionType': actionType,
      'actionValue': actionValue,
      'isActive': isActive,
    };
  }

  BannerEntity toEntity() {
    return BannerEntity(
      id: id,
      desktopImageUrl: desktopImageUrl,
      mobileImageUrl: mobileImageUrl,
      title: title,
      actionType: _mapActionType(actionType),
      actionValue: actionValue,
      isActive: isActive,
    );
  }

  factory BannerModel.fromEntity(BannerEntity entity) {
    return BannerModel(
      id: entity.id,
      desktopImageUrl: entity.desktopImageUrl,
      mobileImageUrl: entity.mobileImageUrl,
      title: entity.title,
      actionType: _unmapActionType(entity.actionType),
      actionValue: entity.actionValue,
      isActive: entity.isActive,
    );
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
