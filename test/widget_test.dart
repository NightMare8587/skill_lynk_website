import 'package:flutter_test/flutter_test.dart';
import 'package:skill_lynk_website/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SkillLynkApp());
    
    // Basic verification that the app starts
    expect(find.byType(SkillLynkApp), findsOneWidget);
  });
}
