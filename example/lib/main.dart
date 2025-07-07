import 'package:flutter/material.dart';
import 'package:clipboard_history/clipboard_history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ClipboardHistory(maxItems: 12);
    return MaterialApp(home: ClipboardHistoryDemo());
  }
}

class ClipboardHistoryDemo extends StatefulWidget {
  @override
  _ClipboardHistoryDemoState createState() => _ClipboardHistoryDemoState();
}

class _ClipboardHistoryDemoState extends State<ClipboardHistoryDemo> {
  final TextEditingController _controller = TextEditingController();
  List<String> _history = [];

  Future<void> _copyText() async {
    await ClipboardHistory.instance.copyText(_controller.text);
    _controller.clear();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await ClipboardHistory.instance.getClipboardHistory();
    setState(() {
      _history = history;
    });
  }

  Future<void> _clearHistory() async {
    await ClipboardHistory.instance.clearHistory();
    _loadHistory();
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clipboard History')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: InputDecoration(labelText: 'Text to copy')),
            Text('Max history items: ${ClipboardHistory.instance.maxItems}'),
            ElevatedButton(onPressed: _copyText, child: Text('Copy Text')),
            ElevatedButton(onPressed: _clearHistory, child: Text('Clear History')),
            SizedBox(height: 20),
            Text('History:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._history.map((item) => ListTile(title: Text(item))),
          ],
        ),
      ),
    );
  }
}