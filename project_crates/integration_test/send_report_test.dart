import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/home.dart';
import 'package:flutter_application_1/screens/searchresult/Selectedlisting_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  group('Send Report', () {
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
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(
          find.byWidgetPredicate((widget) => widget is Home), findsOneWidget);
    }
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Report Listing', (WidgetTester tester) async {
      await login(tester);
      await tester.pumpAndSettle(Duration(seconds: 3));
      // final categoryBtn = find.byKey(Key('All'));
      // await tester.tap(categoryBtn);
      // await tester.pumpAndSettle(Duration(seconds: 2));
      final listingBtn = find
          .byKey(Key('ListingCard'))
          .first;
      await tester.tap(listingBtn);
      await tester.pumpAndSettle(Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) => widget is Selectedlisting_page),
          findsOneWidget);

      final reportBtn = find.byKey(Key('Report'));
      await tester.tap(reportBtn);
      await tester.pumpAndSettle(Duration(seconds: 3));

      final titleField = find.byKey(Key('Title'));
      await tester.tap(titleField);
      await tester.enterText(titleField, 'Item wrong');
      await tester.pumpAndSettle(Duration(seconds: 2));

      final descriptionField = find.byKey(Key('Description'));
      await tester.tap(descriptionField);
      await tester.enterText(descriptionField, 'i think this item should be under dry food');
      await tester.pumpAndSettle(Duration(seconds: 2));

      final sendBtn = find.byKey(Key('SendReport'));
      await tester.tap(sendBtn);
      await tester.pumpAndSettle(Duration(seconds: 3));
    });
  });
}