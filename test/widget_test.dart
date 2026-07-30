// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_transit_kigali/main.dart';
import 'package:smart_transit_kigali/screens/search_route_screen.dart';

void main() {
  testWidgets('renders the Smart Transit splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartTransitApp());
    expect(find.text('Smart Transit'), findsOneWidget);
  });

  testWidgets('lets a rider select a destination before finding a route', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchRouteScreen()));

    expect(tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Find Route')).onPressed, isNull);

    await tester.tap(find.byKey(const Key('destination-picker')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kimironko Market'));
    await tester.pumpAndSettle();

    expect(find.text('To: Kimironko Market'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Find Route')).onPressed, isNotNull);
  });
}
