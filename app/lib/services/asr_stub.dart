import 'package:speech_to_text/speech_to_text.dart' as stt;

class AsrStub {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isInitialized = false;
  
  /// Initialize the speech recognition service
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    try {
      _isInitialized = await _speechToText.initialize(
        onError: (error) => print('ASR Error: $error'),
        onStatus: (status) => print('ASR Status: $status'),
      );
      return _isInitialized;
    } catch (e) {
      print('ASR Initialization failed: $e');
      return false;
    }
  }
  
  /// Perform one-shot speech recognition
  Future<String> listenOnce({
    Duration timeout = const Duration(seconds: 5),
    String localeId = 'de-DE',
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        throw Exception('Speech recognition could not be initialized');
      }
    }
    
    if (!_speechToText.isAvailable) {
      throw Exception('Speech recognition not available');
    }
    
    String recognizedText = '';
    bool isCompleted = false;
    
    await _speechToText.listen(
      onResult: (result) {
        recognizedText = result.recognizedWords;
        if (result.finalResult) {
          isCompleted = true;
        }
      },
      listenFor: timeout,
      pauseFor: const Duration(seconds: 2),
      partialResults: true,
      localeId: localeId,
      cancelOnError: true,
      listenMode: stt.ListenMode.confirmation,
    );
    
    // Wait for completion or timeout
    final startTime = DateTime.now();
    while (!isCompleted && 
           DateTime.now().difference(startTime) < timeout.add(const Duration(seconds: 2))) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    await stop();
    return recognizedText.trim();
  }
  
  /// Stop ongoing speech recognition
  Future<void> stop() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }
  
  /// Check if speech recognition is currently active
  bool get isListening => _speechToText.isListening;
  
  /// Check if speech recognition is available on this device
  bool get isAvailable => _speechToText.isAvailable;
  
  /// Get available locales for speech recognition
  Future<List<stt.LocaleName>> getLocales() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _speechToText.locales();
  }
  
  /// Check if offline speech recognition is supported
  bool get supportsOffline {
    // This would need to be implemented based on device capabilities
    // For now, return false as most implementations require online
    return false;
  }
  
  /// Dispose of resources
  void dispose() {
    if (_speechToText.isListening) {
      _speechToText.stop();
    }
    // Note: speech_to_text doesn't have an explicit dispose method
  }
}