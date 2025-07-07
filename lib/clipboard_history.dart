import 'dart:async';
import 'package:flutter/services.dart';

class ClipboardHistory {
  static final ClipboardHistory instance = ClipboardHistory._internal();
  static const MethodChannel _channel = MethodChannel('clipboard_history');
  int _maxItems = 10;
int get maxItems => _maxItems;
  factory ClipboardHistory({int maxItems = 10}) {
    instance._maxItems = maxItems;
    return instance;
  }

  ClipboardHistory._internal();

  Future<void> copyText(String text) async {
    await _channel.invokeMethod('copyText', {
      'text': text,
      'maxItems': _maxItems,
    });
  }

  Future<String?> getClipboardText() async {
    return await _channel.invokeMethod<String>('getClipboardText');
  }

  Future<List<String>> getClipboardHistory() async {
    final List<dynamic> result = await _channel.invokeMethod('getClipboardHistory');
    return result.cast<String>();
  }

  Future<void> clearHistory() async {
    await _channel.invokeMethod('clearClipboardHistory');
  }

  Future<String?> getPlatformVersion() async {
    return await _channel.invokeMethod<String>('getPlatformVersion');
  }
}