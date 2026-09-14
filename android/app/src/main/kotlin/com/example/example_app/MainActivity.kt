package com.example.example_app

import android.content.Context
import android.hardware.ConsumerIrManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.example_app/ir_emitter"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            val irManager = getSystemService(Context.CONSUMER_IR_SERVICE) as? ConsumerIrManager

            when (call.method) {
                "hasIrEmitter" -> {
                    if (irManager != null && irManager.hasIrEmitter()) {
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
                "transmitHex" -> {
                    val hexCode = call.argument<String>("hexCode")
                    val carrierFrequency = call.argument<Int>("frequency") ?: 38000

                    if (irManager == null || !irManager.hasIrEmitter()) {
                        result.error("NO_IR_EMITTER", "Thiết bị không có mắt phát hồng ngoại", null)
                        return@setMethodCallHandler
                    }

                    if (hexCode == null) {
                        result.error("INVALID_CODE", "Mã Hex rỗng", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val pattern = hexToPattern(hexCode)
                        irManager.transmit(carrierFrequency, pattern)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("TRANSMIT_FAILED", e.message, null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /**
     * Chuyển đổi mã Hex (VD: 0x20DF10EF) hoặc danh sách xung thành pattern microsecond (us) cho ConsumerIrManager.transmit
     */
    private fun hexToPattern(hexStr: String): IntArray {
        var codeStr = hexStr.trim()
        if (codeStr.startsWith("0x") || codeStr.startsWith("0X")) {
            codeStr = codeStr.substring(2)
        }

        // Tách theo dấu phẩy nếu là chuỗi pattern pulse thô (raw pattern us)
        if (codeStr.contains(",")) {
            val parts = codeStr.split(",")
            return parts.mapNotNull { it.trim().toIntOrNull() }.toIntArray()
        }

        val rawVal = codeStr.toLongOrNull(16) ?: 0x20DF10EFL

        // Mẫu giao thức NEC chuẩn: Leading pulse 9000us, Space 4500us
        val patternList = mutableListOf<Int>()
        patternList.add(9000)
        patternList.add(4500)

        // Mã hóa 32-bit (Logical 1: 560us burst + 1690us space; Logical 0: 560us burst + 560us space)
        for (i in 31 downTo 0) {
            val bit = (rawVal shr i) and 1L
            patternList.add(560)
            if (bit == 1L) {
                patternList.add(1690)
            } else {
                patternList.add(560)
            }
        }

        // Stop bit
        patternList.add(560)

        return patternList.toIntArray()
    }
}
