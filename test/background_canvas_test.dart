import 'package:flutter_test/flutter_test.dart';
import 'package:background_canvas/background_canvas.dart';
import 'package:background_canvas/background_canvas_platform_interface.dart';
import 'package:background_canvas/background_canvas_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBackgroundCanvasPlatform
    with MockPlatformInterfaceMixin
    implements BackgroundCanvasPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BackgroundCanvasPlatform initialPlatform = BackgroundCanvasPlatform.instance;

  test('$MethodChannelBackgroundCanvas is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBackgroundCanvas>());
  });

  test('getPlatformVersion', () async {
    BackgroundCanvas backgroundCanvasPlugin = BackgroundCanvas();
    MockBackgroundCanvasPlatform fakePlatform = MockBackgroundCanvasPlatform();
    BackgroundCanvasPlatform.instance = fakePlatform;

    expect(await backgroundCanvasPlugin.getPlatformVersion(), '42');
  });
}
