import 'package:flutter_test/flutter_test.dart';

import 'package:smart_transit_kigali/main.dart';

import 'fakes/fake_repositories.dart';

void main() {
  testWidgets('splash screen routes to login when signed out',
      (WidgetTester tester) async {
    await tester.pumpWidget(SmartTransitApp(
      authRepository: FakeAuthRepository(),
      settingsRepository: FakeSettingsRepository(),
    ));
    await tester.pump();

    expect(find.text('SMART TRANSIT'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pumpAndSettle();

    expect(find.text('SMART TRANSIT'), findsNothing);
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
