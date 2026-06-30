import 'package:eco_cycle/core/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpAtWidth(WidgetTester tester, double width) async {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: ResponsiveLayout(
          mobile: Text('mobile'),
          tablet: Text('tablet'),
          desktop: Text('desktop'),
        ),
      ),
    );
  }

  testWidgets('uses the mobile layout on a phone', (tester) async {
    await pumpAtWidth(tester, 390);

    expect(find.text('mobile'), findsOneWidget);
    expect(find.text('desktop'), findsNothing);
  });

  testWidgets('uses the tablet layout on a tablet', (tester) async {
    await pumpAtWidth(tester, 768);

    expect(find.text('tablet'), findsOneWidget);
  });

  testWidgets('uses the desktop layout on a laptop', (tester) async {
    await pumpAtWidth(tester, 1366);

    expect(find.text('desktop'), findsOneWidget);
    expect(find.text('mobile'), findsNothing);
  });
}
