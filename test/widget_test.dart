import 'package:flutter_test/flutter_test.dart';
import 'package:doanltdd/main.dart';

void main() {
  testWidgets('app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const KineticApp());
    expect(find.byType(KineticApp), findsOneWidget);
  });
}
