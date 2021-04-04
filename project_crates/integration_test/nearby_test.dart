import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_application_1/screens/nearby/nearby.dart' as nearby;
void main() {
  group('Nearby Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('location', (WidgetTester tester) async {
      nearby.Nearby();
      

    });
  });
}