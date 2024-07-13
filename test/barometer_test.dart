import 'package:flutter_test/flutter_test.dart';
import 'package:barometer/barometer.dart';
import 'package:barometer/barometer_platform_interface.dart';
import 'package:barometer/barometer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBarometerPlatform
    with MockPlatformInterfaceMixin
    implements BarometerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<double?> getBarometerReading() => Future.value(79.0);
}

void main() {
  final BarometerPlatform initialPlatform = BarometerPlatform.instance;

  test('$MethodChannelBarometer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBarometer>());
  });

  test('getPlatformVersion', () async {
    Barometer barometerPlugin = Barometer();
    MockBarometerPlatform fakePlatform = MockBarometerPlatform();
    BarometerPlatform.instance = fakePlatform;

    expect(await barometerPlugin.getPlatformVersion(), '42');
  });
}
