package com.example.formosa_app

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.KeyEvent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.formosa_app.volume_buttons"

    private var isLongPress = false
    private var handler: Handler = Handler(Looper.getMainLooper())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Ensure flutterEngine is not null
        val binaryMessenger = flutterEngine?.dartExecutor?.binaryMessenger
        if (binaryMessenger != null) {
            MethodChannel(binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
                // Handle any Flutter method calls if needed
            }
        }
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        if (keyCode == KeyEvent.KEYCODE_VOLUME_UP || keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
            handler.postDelayed({
                isLongPress = true
                notifyFlutter(keyCode, "long")
            }, 500) // Long press threshold (500 ms)

            return true
        }
        return super.onKeyDown(keyCode, event)
    }

    override fun onKeyUp(keyCode: Int, event: KeyEvent): Boolean {
        if (keyCode == KeyEvent.KEYCODE_VOLUME_UP || keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
            if (!isLongPress) {
                notifyFlutter(keyCode, "short")
            }
            isLongPress = false
            handler.removeCallbacksAndMessages(null) // Remove long press callback
            return true
        }
        return super.onKeyUp(keyCode, event)
    }

    private fun notifyFlutter(keyCode: Int, pressType: String) {
        val volumeType = if (keyCode == KeyEvent.KEYCODE_VOLUME_UP) "volume_up" else "volume_down"
        // Ensure flutterEngine is not null
        val binaryMessenger = flutterEngine?.dartExecutor?.binaryMessenger
        if (binaryMessenger != null) {
            MethodChannel(binaryMessenger, CHANNEL).invokeMethod("onVolumeButtonPressed", mapOf("button" to volumeType, "pressType" to pressType))
        }
    }
}
