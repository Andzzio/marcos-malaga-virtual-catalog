import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/shared/data/services/url_launcher_service_impl.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncherPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  String? launchedUrl;
  LaunchOptions? launchOptions;
  bool response = true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrl = url;
    launchOptions = options;
    return response;
  }
}

void main() {
  late UrlLauncherServiceImpl service;
  late MockUrlLauncherPlatform mockPlatform;

  setUp(() {
    service = const UrlLauncherServiceImpl();
    mockPlatform = MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = mockPlatform;
  });

  test('should return false if url is empty or only whitespace', () async {
    expect(await service.launchUrlString(''), isFalse);
    expect(await service.launchUrlString('   '), isFalse);
    expect(mockPlatform.launchedUrl, isNull);
  });

  test('should prepend https:// if url lacks scheme', () async {
    final result = await service.launchUrlString('instagram.com/marcosmalaga');

    expect(result, isTrue);
    expect(mockPlatform.launchedUrl, 'https://instagram.com/marcosmalaga');
  });

  test('should preserve http:// or https:// scheme if present', () async {
    final result = await service.launchUrlString('http://example.com');

    expect(result, isTrue);
    expect(mockPlatform.launchedUrl, 'http://example.com');
  });

  test('should return false when platform returns false', () async {
    mockPlatform.response = false;

    final result = await service.launchUrlString('https://invalid-link.example');

    expect(result, isFalse);
    expect(mockPlatform.launchedUrl, 'https://invalid-link.example');
  });
}
