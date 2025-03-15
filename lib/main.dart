import 'package:demo_app/post.dart';
import 'package:demo_app/text_to_speech.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech to Clipboard',
      home: MyHomePage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('es'), // Spanish
        const Locale('fr'), // French
        const Locale('de'), // German
        const Locale('hi'), // Hindi
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String _selectedLocaleId = 'en_US';
  List<LocaleName> _locales = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _fetchLocales();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    print('Speech initialized: $_speechEnabled');
    setState(() {});
  }

  void _fetchLocales() async {
    _locales = await _speechToText.locales();
    print('Locales fetched: ${_locales.length}');
    // Remove duplicates
    _locales = _locales.toSet().toList();
    setState(() {});
  }

  void _startListening() async {
    if (_speechEnabled) {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: _selectedLocaleId,
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speech recognition not enabled')),
      );
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
    Clipboard.setData(ClipboardData(text: _lastWords));

    if (_lastWords.toLowerCase().contains('redirect to post')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Post()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to Clipboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _locales.isNotEmpty
                ? DropdownButton<String>(
                    value: _selectedLocaleId,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLocaleId = newValue!;
                      });
                    },
                    items: _locales.map<DropdownMenuItem<String>>((locale) {
                      return DropdownMenuItem<String>(
                        value: locale.localeId,
                        child: Text(locale.name),
                      );
                    }).toList(),
                  )
                : CircularProgressIndicator(),
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Text(
              _speechEnabled
                  ? 'Tap the microphone to start listening...'
                  : 'Speech not available',
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(_lastWords),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed:
                _speechToText.isNotListening ? _startListening : _stopListening,
            tooltip: 'Listen',
            child:
                Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Post()),
              );
            },
            tooltip: 'Go to Post',
            child: Icon(Icons.arrow_forward),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TextToSpeech()),
              );
            },
            tooltip: 'Go to tts',
            child: Icon(Icons.phone_in_talk),
          ),
        ],
      ),
    );
  }
}
