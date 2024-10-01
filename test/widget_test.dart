import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/pages/login_page.dart'; // Cambiado a login_page.dart

void main() {
  testWidgets('Login screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(LoginPage());

    // Verify that the login screen is displayed.
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);

    // Enter username and password.
    await tester.enterText(find.byType(TextField).at(0), 'testuser');
    await tester.enterText(find.byType(TextField).at(1), 'password');

    // Tap the login button.
    await tester.tap(find.byIcon(Icons.check));
    
    // Wait for the navigation to complete.
    await tester.pumpAndSettle();

    // Verify navigation to MainPage.
    expect(find.text('Main Page'), findsOneWidget);
  });
}
