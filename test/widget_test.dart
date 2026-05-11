import 'package:flutter_test/flutter_test.dart';
import 'package:strah_mvp/main.dart';

void main() {
  testWidgets('S-TRAH app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StrahApp());
    expect(find.text('S-TRAH'), findsOneWidget);
  });
}
