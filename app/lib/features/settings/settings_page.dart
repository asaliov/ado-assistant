import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _speechEnabled = true;
  bool _navigationVoiceEnabled = true;
  bool _hapticFeedbackEnabled = true;
  double _speechRate = 0.5;
  double _speechVolume = 0.8;
  String _selectedLanguage = 'de-DE';
  
  final List<Map<String, String>> _languages = [
    {'code': 'de-DE', 'name': 'Deutsch'},
    {'code': 'en-US', 'name': 'English (US)'},
    {'code': 'en-GB', 'name': 'English (UK)'},
    {'code': 'fr-FR', 'name': 'Français'},
    {'code': 'es-ES', 'name': 'Español'},
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Speech Settings Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sprache & Audio',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  // Speech enabled toggle
                  SwitchListTile(
                    title: const Text('Sprachausgabe aktiviert'),
                    subtitle: const Text('Text-zu-Sprache für Antworten'),
                    value: _speechEnabled,
                    onChanged: (value) {
                      setState(() {
                        _speechEnabled = value;
                      });
                    },
                  ),
                  
                  // Navigation voice toggle
                  SwitchListTile(
                    title: const Text('Navigationsansagen'),
                    subtitle: const Text('Sprachansagen während der Navigation'),
                    value: _navigationVoiceEnabled,
                    onChanged: (value) {
                      setState(() {
                        _navigationVoiceEnabled = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  // Language selection
                  ListTile(
                    title: const Text('Sprache'),
                    subtitle: Text(_languages.firstWhere((lang) => lang['code'] == _selectedLanguage)['name']!),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: _showLanguageDialog,
                  ),
                  
                  const Divider(),
                  
                  // Speech rate slider
                  ListTile(
                    title: const Text('Sprechgeschwindigkeit'),
                    subtitle: Slider(
                      value: _speechRate,
                      min: 0.1,
                      max: 1.0,
                      divisions: 9,
                      label: '${(_speechRate * 100).round()}%',
                      onChanged: (value) {
                        setState(() {
                          _speechRate = value;
                        });
                      },
                    ),
                  ),
                  
                  // Speech volume slider
                  ListTile(
                    title: const Text('Lautstärke'),
                    subtitle: Slider(
                      value: _speechVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: '${(_speechVolume * 100).round()}%',
                      onChanged: (value) {
                        setState(() {
                          _speechVolume = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Accessibility Settings Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Barrierefreiheit',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  // Haptic feedback toggle
                  SwitchListTile(
                    title: const Text('Haptisches Feedback'),
                    subtitle: const Text('Vibrationen für Bestätigungen'),
                    value: _hapticFeedbackEnabled,
                    onChanged: (value) {
                      setState(() {
                        _hapticFeedbackEnabled = value;
                      });
                    },
                  ),
                  
                  // Large text toggle (placeholder)
                  SwitchListTile(
                    title: const Text('Große Schrift'),
                    subtitle: const Text('Vergrößerte Textdarstellung'),
                    value: false,
                    onChanged: null, // Disabled for now
                  ),
                  
                  // High contrast toggle (placeholder)
                  SwitchListTile(
                    title: const Text('Hoher Kontrast'),
                    subtitle: const Text('Verbesserte Sichtbarkeit'),
                    value: false,
                    onChanged: null, // Disabled for now
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Navigation Settings Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Navigation',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    title: const Text('Offline-Karten'),
                    subtitle: const Text('Karten für Offline-Nutzung herunterladen'),
                    trailing: const Icon(Icons.download),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Offline-Karten werden in einer zukünftigen Version verfügbar sein.'),
                        ),
                      );
                    },
                  ),
                  
                  ListTile(
                    title: const Text('GPS-Genauigkeit'),
                    subtitle: const Text('Hohe Genauigkeit (verbraucht mehr Akku)'),
                    trailing: Switch(
                      value: true,
                      onChanged: null, // Disabled for now
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // App Info Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App-Informationen',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    title: const Text('Version'),
                    subtitle: const Text('1.0.0+1'),
                    trailing: const Icon(Icons.info),
                  ),
                  
                  ListTile(
                    title: const Text('Lizenzen'),
                    subtitle: const Text('Open Source Lizenzen anzeigen'),
                    trailing: const Icon(Icons.description),
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationName: 'Ado Assistant',
                        applicationVersion: '1.0.0+1',
                      );
                    },
                  ),
                  
                  ListTile(
                    title: const Text('Datenschutz'),
                    subtitle: const Text('Datenschutzerklärung anzeigen'),
                    trailing: const Icon(Icons.privacy_tip),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Diese App sammelt keine persönlichen Daten.'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sprache auswählen'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final language = _languages[index];
              return RadioListTile<String>(
                title: Text(language['name']!),
                value: language['code']!,
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }
}