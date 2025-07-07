package com.example.clipboard_history

import android.content.ClipboardManager
import android.content.Context
import android.content.ClipData
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ClipboardHistoryPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private val clipboardHistory = mutableListOf<String>()

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "clipboard_history")
    channel.setMethodCallHandler(this)
    context = binding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    when (call.method) {
      "copyText" -> {
        val text = call.argument<String>("text") ?: ""
        val maxItems = call.argument<Int>("maxItems") ?: 10
        clipboard.setPrimaryClip(ClipData.newPlainText("copied_text", text))
        if (!clipboardHistory.contains(text)) {
          clipboardHistory.add(0, text)
          while (clipboardHistory.size > maxItems) clipboardHistory.removeLast()
        }
        result.success(null)
      }
      "getClipboardText" -> {
        val clipData = clipboard.primaryClip
        if (clipData != null && clipData.itemCount > 0) {
          result.success(clipData.getItemAt(0).coerceToText(context).toString())
        } else {
          result.success(null)
        }
      }
      "getClipboardHistory" -> {
        result.success(clipboardHistory.toList())
      }
      "clearClipboardHistory" -> {
        clipboardHistory.clear()
        result.success(null)
      }
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}