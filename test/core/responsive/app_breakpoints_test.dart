import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eco_cycle/core/responsive/app_breakpoints.dart';

void main() {
  group('AppBreakpoints Tests', () {
    Widget buildContextWrapper(Size size, Widget Function(BuildContext) builder) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: Builder(builder: builder),
        ),
      );
    }

    testWidgets('isMobile returns true for widths < mobile breakpoint (600)', (tester) async {
      bool? isMobile;
      await tester.pumpWidget(buildContextWrapper(const Size(500, 800), (context) {
        isMobile = AppBreakpoints.isMobile(context);
        return const SizedBox();
      }));
      expect(isMobile, isTrue);
    });

    testWidgets('isMobile returns false for widths >= mobile breakpoint (600)', (tester) async {
      bool? isMobile;
      await tester.pumpWidget(buildContextWrapper(const Size(600, 800), (context) {
        isMobile = AppBreakpoints.isMobile(context);
        return const SizedBox();
      }));
      expect(isMobile, isFalse);
    });

    testWidgets('isTablet returns true for widths between mobile (600) and desktop (900)', (tester) async {
      bool? isTablet;
      await tester.pumpWidget(buildContextWrapper(const Size(800, 800), (context) {
        isTablet = AppBreakpoints.isTablet(context);
        return const SizedBox();
      }));
      expect(isTablet, isTrue);
    });

    testWidgets('isTablet returns false for widths >= desktop (900)', (tester) async {
      bool? isTablet;
      await tester.pumpWidget(buildContextWrapper(const Size(950, 800), (context) {
        isTablet = AppBreakpoints.isTablet(context);
        return const SizedBox();
      }));
      expect(isTablet, isFalse);
    });

    testWidgets('isDesktop returns true for widths >= desktop (900)', (tester) async {
      bool? isDesktop;
      await tester.pumpWidget(buildContextWrapper(const Size(1024, 800), (context) {
        isDesktop = AppBreakpoints.isDesktop(context);
        return const SizedBox();
      }));
      expect(isDesktop, isTrue);
    });
  });
}
