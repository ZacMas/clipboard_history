# Clipboard History Plugin for Flutter

A simple cross-platform Flutter plugin to manage clipboard text and maintain a history of copied items. This is useful for productivity apps, text editors, and utilities that require access to previous clipboard entries.

## Features

- Save copied text to history
- Retrieve current clipboard text (non-destructively)
- Get a list of clipboard history
- Clear clipboard history
- Configurable history size

## Getting Started

### Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  clipboard_history:
    path: <Path to clipboard_history>
```

### Usage

```dart
final clipboardHistory = ClipboardHistory(maxItems: 20);
await clipboardHistory.copyText('Hello World');
final history = await clipboardHistory.getClipboardHistory();
final currentClipboard = await clipboardHistory.getClipboardText();
```

### Example UI
Run the example app to try out clipboard operations with a simple interface.

## Platform Support

- Android
- iOS
