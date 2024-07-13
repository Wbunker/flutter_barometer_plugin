package com.thebunkers.barometer

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** BarometerPlugin */
class BarometerPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, SensorEventListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var sensorManager: SensorManager
  private var barometerSensor: Sensor? = null
  private var barometerReading: Double = 0.0
  private var activityBinding: ActivityPluginBinding? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "barometer")
    channel.setMethodCallHandler(this)
    sensorManager = flutterPluginBinding.applicationContext.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    barometerSensor = sensorManager.getDefaultSensor(Sensor.TYPE_PRESSURE)
    barometerSensor?.also { sensor ->
      sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_NORMAL)
    }

  }

  fun getBarometerReading(): Double {
    return barometerReading
  }

  override fun onMethodCall(call: MethodCall, result: Result) {

    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "getBarometerReading" -> result.success(getBarometerReading())
      else -> result.notImplemented()
    }

  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    activityBinding?.let {
      sensorManager.unregisterListener(this, barometerSensor)
    }

  }

  override fun onSensorChanged(event: SensorEvent) {
      if (event.sensor.type == Sensor.TYPE_PRESSURE) {
          barometerReading = event.values[0].toDouble()
      }
  }

    override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {
        // Handle sensor accuracy changes if needed
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        barometerSensor?.also { sensor ->
            sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
         activityBinding = null
        sensorManager.unregisterListener(this, barometerSensor)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
         activityBinding = binding
        barometerSensor?.also { sensor ->
            sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    override fun onDetachedFromActivity() {
        activityBinding = null
        sensorManager.unregisterListener(this, barometerSensor)
    }



}
