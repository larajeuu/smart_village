import 'package:flutter_test/flutter_test.dart';
import 'package:smart_village/main.dart';

void main() {
  testWidgets('Beranda Smart Village tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartVillageApp());
    await tester.pump();

    expect(find.text('Smart Village'), findsOneWidget);
    expect(find.text('Beranda'), findsOneWidget);
  });
}