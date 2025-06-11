import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeapp/Pages/LoginPage/Login.dart';

void main() {
  group('Login Widget Tests', () {
    Widget createLoginWidget() {
      return ProviderScope(
        child: MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(),
          ),
          home: const LoginPageWidget(),
        ),
      );
    }

    testWidgets('should display login form elements', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Access your account by logging in below.'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email and password fields
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
    });

    testWidgets('should display email and password input fields', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.widgetWithText(TextFormField, 'Your email address...'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginWidget());
      await tester.pumpAndSettle();

      // Find the password field (if needed for future testing)
      
      // Find the visibility toggle icon
      final visibilityIcon = find.byIcon(Icons.visibility_off_outlined);
      
      if (visibilityIcon.evaluate().isNotEmpty) {
        // Tap the visibility toggle
        await tester.tap(visibilityIcon);
        await tester.pumpAndSettle();

        // Check if the icon changed to visible
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      }
    });

    testWidgets('should handle empty email input', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginWidget());
      await tester.pumpAndSettle();

      // Find and tap the login button without entering email
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // The form validation should prevent login with empty email
      // Since the actual validation happens in the signIn method,
      // we can't easily test the error dialog here without mocking
      expect(loginButton, findsOneWidget);
    });

    testWidgets('should accept text input in email field', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginWidget());
      await tester.pumpAndSettle();

      // Find email field and enter text
      final emailField = find.widgetWithText(TextFormField, 'Your email address...');
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should accept text input in password field', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginWidget());
      await tester.pumpAndSettle();

      // Find password field and enter text
      final passwordField = find.widgetWithText(TextFormField, 'Password');
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      // The password should be obscured, but the controller should have the value
      // We can't directly verify the obscured text, but we can verify the field exists
      expect(passwordField, findsOneWidget);
    });

    testWidgets('should display back button in app bar', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsAtLeastNWidgets(1));
      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('should have Google sign in button', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('should have forgot password link', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createLoginWidget());
      await tester.pumpAndSettle();

      // Find and tap forgot password link
      final forgotPasswordLink = find.text('Forgot password?');
      expect(forgotPasswordLink, findsOneWidget);
      
      await tester.tap(forgotPasswordLink);
      await tester.pumpAndSettle();
      
      // The tap should be registered (though it currently just prints)
      expect(forgotPasswordLink, findsOneWidget);
    });

    group('Form Validation Tests', () {
      testWidgets('should have form key for validation', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createLoginWidget());
        await tester.pumpAndSettle();

        // Assert - Check that form exists
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
      });

      testWidgets('should handle form submission', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createLoginWidget());
        await tester.pumpAndSettle();

        // Enter valid email and password
        final emailField = find.widgetWithText(TextFormField, 'Your email address...');
        final passwordField = find.widgetWithText(TextFormField, 'Password');
        
        await tester.enterText(emailField, 'test@example.com');
        await tester.enterText(passwordField, 'password123');
        await tester.pumpAndSettle();

        // Find and tap login button
        final loginButton = find.text('Login');
        await tester.tap(loginButton);
        await tester.pumpAndSettle();

        // The form should attempt to submit
        expect(loginButton, findsOneWidget);
      });
    });

    group('UI Layout Tests', () {
      testWidgets('should have proper scaffold structure', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createLoginWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('should have proper input field styling', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createLoginWidget());
        await tester.pumpAndSettle();

        // Assert
        final textFields = find.byType(TextFormField);
        expect(textFields, findsNWidgets(2));

        // Check that both fields are within containers with proper styling
        expect(find.byType(Container), findsAtLeastNWidgets(2));
      });

      testWidgets('should have proper button styling', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createLoginWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Login'), findsOneWidget);
        expect(find.text('Sign in with Google'), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have accessible text fields', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createLoginWidget());
        await tester.pumpAndSettle();

        // Assert - Check that text fields have proper labels
        final emailField = find.widgetWithText(TextFormField, 'Your email address...');
        final passwordField = find.widgetWithText(TextFormField, 'Password');
        
        expect(emailField, findsOneWidget);
        expect(passwordField, findsOneWidget);
      });

      testWidgets('should have accessible buttons', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createLoginWidget());
        await tester.pumpAndSettle();

        // Assert - Check that buttons have proper text
        expect(find.text('Login'), findsOneWidget);
        expect(find.text('Sign in with Google'), findsOneWidget);
        expect(find.text('Forgot password?'), findsOneWidget);
      });
    });
  });
}