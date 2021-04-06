import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/moderator/completedReportListingPage.dart';
import 'package:flutter_application_1/screens/moderator/oneReportListing.dart';
import 'package:flutter_application_1/screens/moderator/oneReportListingCompleted.dart';
import 'package:flutter_application_1/screens/moderator/reportListingPage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {

  group('Moderator Choose Action', () {
    Future<void> login(WidgetTester tester) async {
      app.main();
      //sign_in.SignIn();
      await tester.pumpAndSettle();
      final emailFormField = find.byKey(Key('email'));
      final passwordFormField = find.byKey(Key('password'));
      final loginButton = find.byKey(Key('Login'));

      await tester.tap(emailFormField);
      await tester.enterText(emailFormField, 'admin@crates.com');
      await tester.tap(passwordFormField);
      await tester.enterText(passwordFormField, 'password');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle(Duration(seconds: 3));

      // expect(find.byWidgetPredicate((widget) => widget is ReportListingPage ),findsOneWidget);
    }

    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Dismiss Report', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 2));

      final dismissBtn = find.byKey(Key('DismissReport')).first;
      await tester.tap(dismissBtn);
      await tester.pumpAndSettle(Duration(seconds: 3));

    });

    testWidgets('Choose Actions', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 2));

      final viewBtn = find.byKey(Key('ReportListing')).first;
      await tester.tap(viewBtn);
      await tester.pumpAndSettle(Duration(seconds: 3));
    });

  });
}