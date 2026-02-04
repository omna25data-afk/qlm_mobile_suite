import 'package:flutter_test/flutter_test.dart';
import 'package:qlm_mobile_suite/app.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We use QlmSuiteApp instead of MyApp
    await tester.pumpWidget(const QlmSuiteApp());
    
    // Just verify the app builds without crashing.
    // We can add more specific tests later.
  });
}
