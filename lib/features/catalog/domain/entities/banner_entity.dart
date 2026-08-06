import 'package:equatable/equatable.dart';

enum BannerActionType { openCategory, openProduct, openUrl, none }

class BannerEntity extends Equatable {
  final String id;
  final String desktopImageUrl;
  final String mobileImageUrl;
  final String? title;
  final BannerActionType actionType;
  final String? actionValue;
  final bool isActive;

  const BannerEntity({
    required this.id,
    required this.desktopImageUrl,
    required this.mobileImageUrl,
    this.title,
    required this.actionType,
    this.actionValue,
    required this.isActive,
  });

  BannerEntity copyWith({
    String? id,
    String? desktopImageUrl,
    String? mobileImageUrl,
    String? title,
    BannerActionType? actionType,
    String? actionValue,
    bool? isActive,
  }) {
    return BannerEntity(
      id: id ?? this.id,
      desktopImageUrl: desktopImageUrl ?? this.desktopImageUrl,
      mobileImageUrl: mobileImageUrl ?? this.mobileImageUrl,
      title: title ?? this.title,
      actionType: actionType ?? this.actionType,
      actionValue: actionValue ?? this.actionValue,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    desktopImageUrl,
    mobileImageUrl,
    title,
    actionType,
    actionValue,
    isActive,
  ];
}
