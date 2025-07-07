import Flutter
import UIKit

public class ClipboardHistoryPlugin: NSObject, FlutterPlugin {
  private var clipboardHistory: [String] = []

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "clipboard_history", binaryMessenger: registrar.messenger())
    let instance = ClipboardHistoryPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "copyText":
      if let args = call.arguments as? [String: Any], let text = args["text"] as? String {
        let maxItems = args["maxItems"] as? Int ?? 10
        UIPasteboard.general.string = text
        if !clipboardHistory.contains(text) {
          clipboardHistory.insert(text, at: 0)
          while clipboardHistory.count > maxItems { clipboardHistory.removeLast() }
        }
        result(nil)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing text", details: nil))
      }
    case "getClipboardText":
      result(UIPasteboard.general.string)
    case "getClipboardHistory":
      result(clipboardHistory)
    case "clearClipboardHistory":
      clipboardHistory.removeAll()
      result(nil)
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}