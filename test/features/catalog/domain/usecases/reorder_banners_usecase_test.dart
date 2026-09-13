import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/reorder_banners_usecase.dart';

class MockBannersRepository extends Mock implements BannersRepository {}

void main() {
  late ReorderBannersUsecase usecase;
  late MockBannersRepository mockRepo;

  setUp(() {
    mockRepo = MockBannersRepository();
    usecase = ReorderBannersUsecase(repo: mockRepo);
  });

  final tIds = ['BANNER-003', 'BANNER-001', 'BANNER-002'];

  group('ReorderBannersUsecase Tests', () {
    test('should call repository.reorderBanners with list of ids', () async {
      when(() => mockRepo.reorderBanners(tIds)).thenAnswer((_) async {});

      await usecase(tIds);

      verify(() => mockRepo.reorderBanners(tIds)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
