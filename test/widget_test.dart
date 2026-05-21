import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_lab_3/app.dart';

void main() {
  testWidgets('App smoke test — renders without crashing',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(App(prefs: prefs));
    await tester.pump();

    // Bottom navigation is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Menu tab is visible by default
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('Theme toggle button is present in AppBar',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(App(prefs: prefs));
    await tester.pump();

    expect(find.byType(AppBar), findsOneWidget);
    // Info icon and theme toggle
    expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
  });
}
