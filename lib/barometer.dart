// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:flutter/services.dart';

import 'barometer_platform_interface.dart';

class Barometer {
  static const EventChannel _barometerEventChannel =
      EventChannel('barometer/barometerEvent');

  static Stream<double>? _barometerStream;

  Future<String?> getPlatformVersion() {
    return BarometerPlatform.instance.getPlatformVersion();
  }

  Future<double?> getBarometerReading() {
    return BarometerPlatform.instance.getBarometerReading();
  }

  static Stream<double> get barometerStream {
    _barometerStream ??=
        _barometerEventChannel.receiveBroadcastStream().cast<double>();

    return _barometerStream as Stream<double>;
  }
}
