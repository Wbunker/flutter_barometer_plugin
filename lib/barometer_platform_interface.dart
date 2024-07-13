import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'barometer_method_channel.dart';

abstract class BarometerPlatform extends PlatformInterface {
  /// Constructs a BarometerPlatform.
  BarometerPlatform() : super(token: _token);

  static final Object _token = Object();

  static BarometerPlatform _instance = MethodChannelBarometer();

  /// The default instance of [BarometerPlatform] to use.
  ///
  /// Defaults to [MethodChannelBarometer].
  static BarometerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BarometerPlatform] when
  /// they register themselves.
  static set instance(BarometerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<double?> getBarometerReading() {
    throw UnimplementedError('getBarometer() has not been implemented.');
  }
}
