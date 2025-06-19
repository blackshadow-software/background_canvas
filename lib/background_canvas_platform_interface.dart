import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'background_canvas_method_channel.dart';

abstract class BackgroundCanvasPlatform extends PlatformInterface {
  /// Constructs a BackgroundCanvasPlatform.
  BackgroundCanvasPlatform() : super(token: _token);

  static final Object _token = Object();

  static BackgroundCanvasPlatform _instance = MethodChannelBackgroundCanvas();

  /// The default instance of [BackgroundCanvasPlatform] to use.
  ///
  /// Defaults to [MethodChannelBackgroundCanvas].
  static BackgroundCanvasPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BackgroundCanvasPlatform] when
  /// they register themselves.
  static set instance(BackgroundCanvasPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
