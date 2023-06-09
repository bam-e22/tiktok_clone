// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone/features/authentication/views/widgets/form_button.dart';

void main() {
  group("Form Button Tests", () {
    testWidgets("Enabled State", (WidgetTester tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: FormButton(enabled: true),
        ),
      );

      expect(find.text("Next"), findsOneWidget);
      expect(
        tester
            .firstWidget<AnimatedDefaultTextStyle>(
                find.byType(AnimatedDefaultTextStyle))
            .style
            .color,
        Colors.white,
      );
    });

    testWidgets("Enabled State. background color is primary color",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Theme(
          data: ThemeData(primaryColor: Colors.red),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: FormButton(enabled: true),
          ),
        ),
      );

      expect(find.text("Next"), findsOneWidget);
      expect(
        (tester
                .firstWidget<AnimatedContainer>(find.byType(AnimatedContainer))
                .decoration as BoxDecoration)
            .color,
        Colors.red,
      );
    });

    testWidgets("Disabled State", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: FormButton(enabled: false),
          ),
        ),
      );

      expect(find.text("Next"), findsOneWidget);
      expect(
        tester
            .firstWidget<AnimatedDefaultTextStyle>(
                find.byType(AnimatedDefaultTextStyle))
            .style
            .color,
        Colors.grey.shade400,
      );
    });

    testWidgets("Disabled State, DarkMode", (WidgetTester tester) async {
      await tester.pumpWidget(const MediaQuery(
        data: MediaQueryData(platformBrightness: Brightness.dark),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: FormButton(enabled: false),
        ),
      ));

      expect(
        (tester
                .firstWidget<AnimatedContainer>(find.byType(AnimatedContainer))
                .decoration as BoxDecoration)
            .color,
        Colors.grey.shade800,
      );
    });

    testWidgets("Disabled State, LightMode", (WidgetTester tester) async {
      await tester.pumpWidget(const MediaQuery(
        data: MediaQueryData(platformBrightness: Brightness.light),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: FormButton(enabled: false),
        ),
      ));

      expect(
        (tester
                .firstWidget<AnimatedContainer>(find.byType(AnimatedContainer))
                .decoration as BoxDecoration)
            .color,
        Colors.grey.shade300,
      );
    });
  });
}
