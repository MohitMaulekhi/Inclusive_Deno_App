import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech extends StatefulWidget {
  const TextToSpeech({super.key});

  @override
  _TextToSpeechState createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  final FlutterTts _flutterTts = FlutterTts();
  String _text = "Hello, this is a text-to-speech example.";

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(_text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text to Speech'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _text = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter text to speak',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _speak,
              child: Text('Speak'),
            ),
          ],
        ),
      ),
    );
  }
}
