import Flutter
import UIKit
import CoreMotion

public class BarometerPlugin: NSObject, FlutterPlugin {
  private var eventSink: FlutterEventSink?
  private let altimeter = CMAltimeter()
  private var currentPressure: Double = 0.0

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "barometer", binaryMessenger: registrar.messenger())
    let instance = BarometerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    let eventChannel = FlutterEventChannel(name: "barometer/barometerEvent", binaryMessenger: registrar.messenger())
    eventChannel.setStreamHandler(instance)
    instance.startBarometerUpdates()

  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getBarometerReading":
      result(currentPressure)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func startBarometerUpdates() {
    if CMAltimeter.isRelativeAltitudeAvailable() {
      altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { [weak self] data, error in
        if let error = error {
          // Log error or handle it appropriately
          print("Barometer sensor error: \(error.localizedDescription)")
          return
        }
        if let pressure = data?.pressure.doubleValue {
          self?.currentPressure = pressure * 10 // Convert kPa to hPa 
            self?.eventSink?(self?.currentPressure)
        }
      }
    } else {
      print("Barometer sensor is not available on this device")
    }
  }
  
  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    altimeter.stopRelativeAltitudeUpdates()
  }

}

extension BarometerPlugin: FlutterStreamHandler {
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
