import 'package:marcos_malaga_app/app/core/data/models/store_schedule_model.dart';
import 'package:marcos_malaga_app/app/core/data/models/store_location_model.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_info_entity.dart';

class StoreInfoModel {
  final String address;
  final String reference;
  final String ruc;
  final String businessName;
  final String whatsappNumber;
  final StoreScheduleModel schedule;
  final StoreLocationModel location;

  const StoreInfoModel({
    required this.address,
    required this.reference,
    required this.ruc,
    required this.businessName,
    required this.whatsappNumber,
    required this.schedule,
    required this.location,
  });

  factory StoreInfoModel.fromJson(Map<String, dynamic> json) {
    return StoreInfoModel(
      address: json['address'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      ruc: json['ruc'] as String? ?? '',
      businessName: json['businessName'] as String? ?? '',
      whatsappNumber: json['whatsappNumber'] as String? ?? '',
      schedule: StoreScheduleModel.fromJson(
        json['schedule'] as Map<String, dynamic>,
      ),
      location: StoreLocationModel.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
    );
  }

  StoreInfoEntity toEntity() {
    return StoreInfoEntity(
      address: address,
      reference: reference,
      ruc: ruc,
      businessName: businessName,
      whatsappNumber: whatsappNumber,
      schedule: schedule.toEntity(),
      location: location.toEntity(),
    );
  }
}
