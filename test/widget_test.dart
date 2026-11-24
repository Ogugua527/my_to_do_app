import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_to_do_app/screens/intro_screen.dart';

void main() {
  testWidgets('IntroPage smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: IntroPage()));

    expect(find.text('Daily Planner'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
