import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'barometer_platform_interface.dart';

/// An implementation of [BarometerPlatform] that uses method channels.
class MethodChannelBarometer extends BarometerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('barometer');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<double?> getBarometerReading() async {
    final reading =
        await methodChannel.invokeMethod<double>('getBarometerReading');
    return reading;
  }
}
