// Home Management App Widget Tests
//
// This file contains basic widget tests for the Home Management App.
// The app implements a role-based authentication system with three user types:
// homeowner, tenant, and landlord.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:homeapp/main.dart';

void main() {
  group('Home Management App Tests', () {
    testWidgets('App should build and display initial widget', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(HomeApp());
      await tester.pumpAndSettle();

      // Verify that the app builds successfully
      expect(find.byType(ProviderScope), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should have proper material app configuration', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(HomeApp());
      await tester.pumpAndSettle();

      // Find the MaterialApp widget
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      // Verify basic app configuration
      expect(materialApp.title, equals('HomeApp'));
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
    });

    testWidgets('App should handle initial routing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(HomeApp());
      
      // Allow for potential async operations to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // The app should display some kind of scaffold or material component
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('App should use Riverpod for state management', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(HomeApp());
      await tester.pumpAndSettle();

      // Verify that ProviderScope is present (indicates Riverpod integration)
      expect(find.byType(ProviderScope), findsOneWidget);
    });
  });
}
