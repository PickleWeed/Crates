import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/moderator/completedReportListingPage.dart';
import 'package:flutter_application_1/screens/moderator/reportListingPage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  group('Moderator Search', () {
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

      expect(find.byWidgetPredicate((widget) => widget is ReportListingPage),
          findsOneWidget);
    }

    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Search reported listings', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 2));

      final searchBtn = find.byKey(Key('SearchReport'));
      await tester.tap(searchBtn);
      await tester.enterText(searchBtn, 'sus');
      await tester.pumpAndSettle(Duration(seconds: 3));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(Duration(seconds: 7));
    });

    testWidgets('Sort Reported Listings', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final sortBtn = find.byIcon(Icons.sort);
      await tester.tap(sortBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));
    });

    testWidgets('Search completed listings', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final completedReportBtn = find.byIcon(Icons.note);
      await tester.tap(completedReportBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(
          find.byWidgetPredicate(
              (widget) => widget is CompletedReportListingPage),
          findsOneWidget);

      final searchBtn = find.byKey(Key('SearchCompleted'));
      await tester.tap(searchBtn);
      await tester.enterText(searchBtn, 'food');
      await tester.pumpAndSettle(Duration(seconds: 3));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(Duration(seconds: 5));
    });

    testWidgets('Sort Completed Listings', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final completedReportBtn = find.byIcon(Icons.note);
      await tester.tap(completedReportBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));

      expect(
          find.byWidgetPredicate(
              (widget) => widget is CompletedReportListingPage),
          findsOneWidget);

      final sortBtn = find.byIcon(Icons.sort);
      await tester.tap(sortBtn);
      await tester.pumpAndSettle(Duration(seconds: 5));
    });
  });
}
