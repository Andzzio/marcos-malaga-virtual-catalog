import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/services/url_launcher_service.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/launch_external_url_usecase.dart';

class MockUrlLauncherService extends Mock implements UrlLauncherService {}

void main() {
  late MockUrlLauncherService mockService;
  late LaunchExternalUrlUsecase usecase;

  setUp(() {
    mockService = MockUrlLauncherService();
    usecase = LaunchExternalUrlUsecase(service: mockService);
  });

  test('should forward url to UrlLauncherService and return result', () async {
    const testUrl = 'https://instagram.com/marcosmalaga';
    when(() => mockService.launchUrlString(testUrl)).thenAnswer((_) async => true);

    final result = await usecase(testUrl);

    expect(result, isTrue);
    verify(() => mockService.launchUrlString(testUrl)).called(1);
    verifyNoMoreInteractions(mockService);
  });

  test('should return false when UrlLauncherService returns false', () async {
    const testUrl = 'invalid-url';
    when(() => mockService.launchUrlString(testUrl)).thenAnswer((_) async => false);

    final result = await usecase(testUrl);

    expect(result, isFalse);
    verify(() => mockService.launchUrlString(testUrl)).called(1);
    verifyNoMoreInteractions(mockService);
  });
}
