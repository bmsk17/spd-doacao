package com.example.flutter_maps

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.eldorado.vini/somar").setMethodCallHandler {
            call, result ->

            if (call.method == "somar") {
                val num1 = call.argument<Int>("num1") ?: 0
                val num2 = call.argument<Int>("num2") ?: 0
                result.success(num1 + num2)
            } else {
                result.notImplemented()
            }
        }
    }
}
