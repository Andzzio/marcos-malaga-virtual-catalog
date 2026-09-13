import 'package:equatable/equatable.dart';

enum BannerActionType { openCategory, openProduct, openUrl, none }

enum BannerMediaType { image, video }

class BannerEntity extends Equatable {
  final String id;
  final String? title;
  final String desktopUrl;
  final BannerMediaType desktopMediaType;
  final String mobileUrl;
  final BannerMediaType mobileMediaType;
  final BannerActionType actionType;
  final String? actionValue;
  final bool isActive;
  final int index;
  final DateTime? createdAt;

  const BannerEntity({
    required this.id,
    this.title,
    required this.desktopUrl,
    this.desktopMediaType = BannerMediaType.image,
    required this.mobileUrl,
    this.mobileMediaType = BannerMediaType.image,
    required this.actionType,
    this.actionValue,
    this.isActive = true,
    this.index = 0,
    this.createdAt,
  });

  // Business logic helpers
  bool get hasAction =>
      actionType != BannerActionType.none &&
      actionValue != null &&
      actionValue!.trim().isNotEmpty;

  bool get isVideo =>
      desktopMediaType == BannerMediaType.video ||
      mobileMediaType == BannerMediaType.video;

  bool get isOpenCategory => actionType == BannerActionType.openCategory;
  bool get isOpenProduct => actionType == BannerActionType.openProduct;
  bool get isOpenUrl => actionType == BannerActionType.openUrl;

  BannerEntity copyWith({
    String? id,
    String? title,
    String? desktopUrl,
    BannerMediaType? desktopMediaType,
    String? mobileUrl,
    BannerMediaType? mobileMediaType,
    BannerActionType? actionType,
    String? actionValue,
    bool? isActive,
    int? index,
    DateTime? createdAt,
  }) {
    return BannerEntity(
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

  @override
  List<Object?> get props => [
    id,
    title,
    desktopUrl,
    desktopMediaType,
    mobileUrl,
    mobileMediaType,
    actionType,
    actionValue,
    isActive,
    index,
    createdAt,
  ];
}
