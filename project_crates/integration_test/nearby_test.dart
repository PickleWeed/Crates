import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/screens/nearby/nearby.dart' as nearby;

void main() {
  group('Nearby Test', () {

    Future<void> login(WidgetTester tester) async {
      app.main();
      //sign_in.SignIn();
      await tester.pumpAndSettle();
      final emailFormField = find.byKey(Key('email'));
      final passwordFormField = find.byKey(Key('password'));
      final loginButton = find.byKey(Key('Login'));


      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'testuser@gmail.com');
      await tester.tap(passwordFormField);
      await tester.enterText(passwordFormField, 'password');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 5));

      final loginFinder = find.text('Login Successful');

      expect(find.byWidgetPredicate((widget) => widget is Home),findsOneWidget);
    }


    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('location', (WidgetTester tester) async {
      nearby.Nearby();
      

    });
  });
}