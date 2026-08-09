import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/core/data/datasources/local_store_info_datasource.dart';
import 'package:marcos_malaga_app/app/core/data/models/store_info_model.dart';
import 'package:marcos_malaga_app/app/core/data/models/store_schedule_model.dart';
import 'package:marcos_malaga_app/app/core/data/models/store_location_model.dart';
import 'package:marcos_malaga_app/app/core/data/repositories/local_store_info_repository_impl.dart';

class FakeLocalStoreInfoDatasource implements LocalStoreInfoDatasource {
  @override
  Future<StoreInfoModel?> fetchStoreInfo() async {
    return const StoreInfoModel(
      address: 'Test',
      reference: 'Ref',
      ruc: '123',
      businessName: 'Fake Store',
      whatsappNumber: '111',
      schedule: StoreScheduleModel(
        regularHours: [],
        exceptions: [],
        timeZone: 'UTC',
      ),
      location: StoreLocationModel(latitude: 0.0, longitude: 0.0),
    );
  }
}

void main() {
  late LocalStoreInfoRepositoryImpl repository;
  late FakeLocalStoreInfoDatasource fakeDatasource;

  setUp(() {
    fakeDatasource = FakeLocalStoreInfoDatasource();
    repository = LocalStoreInfoRepositoryImpl(datasource: fakeDatasource);
  });

  test('getStoreInfo debe retornar StoreInfoEntity', () async {
    final result = await repository.getStoreInfo();
    expect(result.businessName, 'Fake Store');
  });
}
