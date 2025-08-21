import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'core/intent_router.dart';
import 'services/asr_stub.dart';
import 'services/tts_stub.dart';
import 'features/navigation/navigation_stub.dart';
import 'features/settings/settings_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<IntentRouter>(create: (_) => IntentRouter()),
        Provider<AsrStub>(create: (_) => AsrStub()),
        Provider<TtsStub>(create: (_) => TtsStub()),
        Provider<NavigationService>(create: (_) => NavigationService()),
      ],
      child: const AdoAssistantApp(),
    ),
  );
}

class AdoAssistantApp extends StatelessWidget {
  const AdoAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ado Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isListening = false;
  bool _permissionsGranted = false;
  String _lastRecognizedText = '';
  String _lastResponse = '';

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.microphone,
      Permission.location,
      Permission.camera,
    ];

    Map<Permission, PermissionStatus> statuses = await permissions.request();
    
    bool allGranted = statuses.values.every(
      (status) => status == PermissionStatus.granted,
    );

    setState(() {
      _permissionsGranted = allGranted;
    });

    if (!allGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Einige Berechtigungen wurden nicht gewährt. '
                        'Die App funktioniert möglicherweise nicht vollständig.'),
          ),
        );
      }
    }
  }

  Future<void> _startSpeechRecognition() async {
    if (!_permissionsGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mikrofon-Berechtigung erforderlich für Spracherkennung.'),
        ),
      );
      return;
    }

    setState(() {
      _isListening = true;
    });

    try {
      final asrService = context.read<AsrStub>();
      final intentRouter = context.read<IntentRouter>();
      final ttsService = context.read<TtsStub>();

      final recognizedText = await asrService.listenOnce();
      
      setState(() {
        _lastRecognizedText = recognizedText;
      });

      if (recognizedText.isNotEmpty) {
        final response = intentRouter.handle(recognizedText);
        
        setState(() {
          _lastResponse = response;
        });

        await ttsService.speak(response);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler bei Spracherkennung: $e')),
        );
      }
    } finally {
      setState(() {
        _isListening = false;
      });
    }
  }

  void _openNavigation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NavigationStubPage()),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Ado Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('Berechtigungen: ${_permissionsGranted ? "✓" : "✗"}'),
                    Text('Mikrofon aktiv: ${_isListening ? "Ja" : "Nein"}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_lastRecognizedText.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Erkannter Text',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(_lastRecognizedText),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_lastResponse.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Antwort',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(_lastResponse),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _isListening ? null : _startSpeechRecognition,
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
              label: Text(_isListening ? 'Höre zu...' : 'Spracherkennung starten'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _openNavigation,
              icon: const Icon(Icons.navigation),
              label: const Text('Navigation öffnen'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}