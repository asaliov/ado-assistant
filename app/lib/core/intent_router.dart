class IntentRouter {
  /// Handles user input and routes to appropriate responses
  /// Currently uses simple German keyword matching
  String handle(String input) {
    final normalizedInput = input.toLowerCase().trim();
    
    // Navigation intents
    if (_containsAny(normalizedInput, ['navigation', 'navigiere', 'route', 'weg', 'fahren', 'gehen'])) {
      return 'Öffne Navigation. Wohin möchtest du gehen?';
    }
    
    // Location/position intents
    if (_containsAny(normalizedInput, ['wo bin ich', 'position', 'standort', 'ort'])) {
      return 'Du befindest dich derzeit an einer unbekannten Position. GPS wird initialisiert.';
    }
    
    // Help intents
    if (_containsAny(normalizedInput, ['hilfe', 'help', 'was kannst du', 'funktionen'])) {
      return 'Ich kann dir bei Navigation helfen, deinen Standort ermitteln und Sprachbefehle verstehen. '
             'Sage "Navigation" um zu navigieren oder "Wo bin ich" für deinen Standort.';
    }
    
    // Time intents
    if (_containsAny(normalizedInput, ['uhrzeit', 'zeit', 'wie spät'])) {
      final now = DateTime.now();
      return 'Es ist ${now.hour}:${now.minute.toString().padLeft(2, '0')} Uhr.';
    }
    
    // Weather intents (placeholder)
    if (_containsAny(normalizedInput, ['wetter', 'weather', 'temperatur', 'regen'])) {
      return 'Wetterdaten sind offline nicht verfügbar. Verbinde dich mit dem Internet für aktuelle Wetterinformationen.';
    }
    
    // Emergency intents
    if (_containsAny(normalizedInput, ['notfall', 'emergency', 'hilfe rufen', 'notruf'])) {
      return 'Für Notfälle wähle 112. Soll ich die Notfallkontakte anzeigen?';
    }
    
    // Settings intents
    if (_containsAny(normalizedInput, ['einstellungen', 'settings', 'konfiguration'])) {
      return 'Öffne Einstellungen um die App zu konfigurieren.';
    }
    
    // Greeting intents
    if (_containsAny(normalizedInput, ['hallo', 'hi', 'hey', 'guten tag', 'guten morgen', 'guten abend'])) {
      return 'Hallo! Ich bin dein Ado Assistant. Wie kann ich dir helfen?';
    }
    
    // Default response
    return 'Entschuldigung, ich habe das nicht verstanden. '
           'Versuche es mit "Hilfe" für verfügbare Befehle.';
  }
  
  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }
}