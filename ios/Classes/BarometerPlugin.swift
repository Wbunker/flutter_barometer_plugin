import Flutter
import UIKit
import CoreMotion

public class BarometerPlugin: NSObject, FlutterPlugin {
  private let altimeter = CMAltimeter()
  private var currentPressure: Double = 0.0

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "barometer", binaryMessenger: registrar.messenger())
    let instance = BarometerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    instance.startBarometerUpdates()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getBarometer":
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
          self?.currentPressure = pressure * 10 // Convert kPa to hPa (if needed)
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
