import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_cipatumblerbarulecet/main.dart';

void main() {
  testWidgets('Keripikroll App smoke test', (WidgetTester tester) async {
    // Build our app with login status false
    await tester.pumpWidget(const KeripikrollApp(isLoggedIn: false));

    // Verify Keripikroll title is present
    expect(find.text('Keripikroll'), findsWidgets);
    expect(find.text('Login'), findsOneWidget);
  });
}
