import 'package:latlong2/latlong.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_info_entity.dart';
import 'package:marcos_malaga_app/app/core/presentation/models/store_map_ui_model.dart';

class StoreMapUiMapper {
  StoreMapUiMapper._();

  static StoreMapUiModel fromEntity(StoreInfoEntity entity) {
    return StoreMapUiModel(
      coordinates: LatLng(entity.location.latitude, entity.location.longitude),
    );
  }
}
