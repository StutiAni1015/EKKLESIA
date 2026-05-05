import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ekklesia/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      EkklesiaApp(home: const Scaffold(body: SizedBox())),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
