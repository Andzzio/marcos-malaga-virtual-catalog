import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_info_entity.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_schedule_entity.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_location_entity.dart';
import 'package:marcos_malaga_app/app/core/domain/repositories/store_info_repository.dart';
import 'package:marcos_malaga_app/app/core/domain/usecases/get_store_info_usecase.dart';

class FakeStoreInfoRepository implements StoreInfoRepository {
  @override
  Future<StoreInfoEntity> getStoreInfo() async {
    return const StoreInfoEntity(
      address: 'Test',
      reference: 'Ref',
      ruc: '123',
      businessName: 'Fake Usecase Store',
      whatsappNumber: '111',
      schedule: StoreScheduleEntity(
        regularHours: [],
        exceptions: [],
        timeZone: 'UTC',
      ),
      location: StoreLocationEntity(latitude: 0.0, longitude: 0.0),
    );
  }
}

void main() {
  late GetStoreInfoUsecase usecase;
  late FakeStoreInfoRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeStoreInfoRepository();
    usecase = GetStoreInfoUsecase(repo: fakeRepository);
  });

  test('call debe retornar StoreInfoEntity desde el repositorio', () async {
    final result = await usecase();
    expect(result.businessName, 'Fake Usecase Store');
  });
}
