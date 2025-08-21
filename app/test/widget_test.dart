import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ado_assistant/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AdoAssistantApp());

    // Verify that the app loads.
    expect(find.text('Ado Assistant'), findsOneWidget);
  });
  
  testWidgets('Main page displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const AdoAssistantApp());

    // Verify main elements are present.
    expect(find.text('Status'), findsOneWidget);
    expect(find.text('Spracherkennung starten'), findsOneWidget);
    expect(find.text('Navigation öffnen'), findsOneWidget);
  });
}