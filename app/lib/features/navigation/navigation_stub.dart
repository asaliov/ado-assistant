import 'package:flutter/material.dart';

/// Navigation service for offline-first navigation
class NavigationService {
  // Placeholder for future offline navigation capabilities
  String _currentLocation = 'Unbekannt';
  List<String> _recentDestinations = [];
  
  /// Get current location (placeholder)
  String get currentLocation => _currentLocation;
  
  /// Get recent destinations
  List<String> get recentDestinations => List.unmodifiable(_recentDestinations);
  
  /// Add a destination to recent list
  void addRecentDestination(String destination) {
    _recentDestinations.insert(0, destination);
    if (_recentDestinations.length > 10) {
      _recentDestinations.removeLast();
    }
  }
  
  /// Calculate route (placeholder)
  Future<NavigationRoute?> calculateRoute(String destination) async {
    // Simulate route calculation
    await Future.delayed(const Duration(seconds: 1));
    
    return NavigationRoute(
      destination: destination,
      estimatedDuration: const Duration(minutes: 15),
      distance: 1.2,
      instructions: [
        'Geradeaus gehen für 200m',
        'Links abbiegen in die Hauptstraße',
        'Nach 500m rechts abbiegen',
        'Ziel erreicht',
      ],
    );
  }
  
  /// Start navigation (placeholder)
  Future<void> startNavigation(NavigationRoute route) async {
    addRecentDestination(route.destination);
    // Placeholder for actual navigation start
  }
}

/// Navigation route data class
class NavigationRoute {
  final String destination;
  final Duration estimatedDuration;
  final double distance; // in kilometers
  final List<String> instructions;
  
  NavigationRoute({
    required this.destination,
    required this.estimatedDuration,
    required this.distance,
    required this.instructions,
  });
}

/// Navigation stub page with MapLibre placeholder
class NavigationStubPage extends StatefulWidget {
  const NavigationStubPage({super.key});
  
  @override
  State<NavigationStubPage> createState() => _NavigationStubPageState();
}

class _NavigationStubPageState extends State<NavigationStubPage> {
  final TextEditingController _destinationController = TextEditingController();
  NavigationRoute? _currentRoute;
  bool _isCalculating = false;
  
  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }
  
  Future<void> _calculateRoute() async {
    if (_destinationController.text.trim().isEmpty) return;
    
    setState(() {
      _isCalculating = true;
    });
    
    try {
      final navigationService = NavigationService();
      final route = await navigationService.calculateRoute(_destinationController.text.trim());
      
      setState(() {
        _currentRoute = route;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler bei Routenberechnung: $e')),
        );
      }
    } finally {
      setState(() {
        _isCalculating = false;
      });
    }
  }
  
  Future<void> _startNavigation() async {
    if (_currentRoute == null) return;
    
    try {
      final navigationService = NavigationService();
      await navigationService.startNavigation(_currentRoute!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigation gestartet')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Starten der Navigation: $e')),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Map placeholder
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'MapLibre Offline-Karte',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Wird in zukünftiger Version implementiert',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Destination input
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Ziel eingeben',
                hintText: 'z.B. Hauptbahnhof, Marktplatz 5',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              onSubmitted: (_) => _calculateRoute(),
            ),
            const SizedBox(height: 16),
            
            // Calculate route button
            ElevatedButton.icon(
              onPressed: _isCalculating ? null : _calculateRoute,
              icon: _isCalculating 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.route),
              label: Text(_isCalculating ? 'Berechne...' : 'Route berechnen'),
            ),
            const SizedBox(height: 16),
            
            // Route information
            if (_currentRoute != null) ...[
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Route nach ${_currentRoute!.destination}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text('Entfernung: ${_currentRoute!.distance.toStringAsFixed(1)} km'),
                        Text('Geschätzte Dauer: ${_currentRoute!.estimatedDuration.inMinutes} Min'),
                        const SizedBox(height: 12),
                        Text(
                          'Anweisungen:',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _currentRoute!.instructions.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Text('${index + 1}. ${_currentRoute!.instructions[index]}'),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _startNavigation,
                icon: const Icon(Icons.navigation),
                label: const Text('Navigation starten'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}