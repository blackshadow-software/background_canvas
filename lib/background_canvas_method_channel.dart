import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'background_canvas_platform_interface.dart';

/// An implementation of [BackgroundCanvasPlatform] that uses method channels.
class MethodChannelBackgroundCanvas extends BackgroundCanvasPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('background_canvas');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
