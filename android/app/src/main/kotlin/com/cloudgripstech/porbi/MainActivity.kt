package com.porbi.apk

import android.net.Uri
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.porbi.apk/content"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "copyContentUri") {
                val uriString = call.argument<String>("uri")
                if (uriString != null) {
                    try {
                        val uri = Uri.parse(uriString)
                        val cacheDir = context.cacheDir
                        var fileName = "temp_file"

                        context.contentResolver.query(uri, null, null, null, null)?.use { cursor ->
                            if (cursor.moveToFirst()) {
                                val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                                if (nameIndex != -1) {
                                    fileName = cursor.getString(nameIndex)
                                }
                            }
                        }

                        val destFile = File(cacheDir, fileName)
                        context.contentResolver.openInputStream(uri)?.use { input ->
                            FileOutputStream(destFile).use { output ->
                                input.copyTo(output)
                            }
                        }
                        result.success(destFile.absolutePath)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                } else {
                    result.error("INVALID", "URI is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
