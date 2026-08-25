import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:panther_app/main.dart';

void main() {
  testWidgets('PantherApp boots to the welcome or splash screen', (tester) async {
    await tester.pumpWidget(const PantherApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
