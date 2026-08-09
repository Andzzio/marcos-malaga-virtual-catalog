import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_location_entity.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_schedule_entity.dart';

class StoreInfoEntity extends Equatable {
  final String address;
  final String reference;
  final String ruc;
  final String businessName;
  final String whatsappNumber;
  final StoreScheduleEntity schedule;
  final StoreLocationEntity location;

  const StoreInfoEntity({
    required this.address,
    required this.reference,
    required this.ruc,
    required this.businessName,
    required this.whatsappNumber,
    required this.schedule,
    required this.location,
  });

  @override
  List<Object?> get props => [
        address,
        reference,
        ruc,
        businessName,
        whatsappNumber,
        schedule,
        location,
      ];
}
