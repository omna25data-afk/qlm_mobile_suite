import 'package:flutter_test/flutter_test.dart';
import 'package:qlm_mobile_suite/app.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QlmSuiteApp());
  });
}
