import 'package:flutter_test/flutter_test.dart';

import 'package:church_management_app/main.dart';

void main() {
  testWidgets('member demo account signs in and displays its role', (
    tester,
  ) async {
    await tester.pumpWidget(const ChurchApp());

    expect(find.text('Welcome to EcclSync'), findsOneWidget);
    await tester.ensureVisible(find.text('Member'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Member'));
    await tester.ensureVisible(find.text('Sign in to demo'));
    await tester.tap(find.text('Sign in to demo'));
    await tester.pumpAndSettle();

    expect(find.text('Good day, Maria'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Maria Santos'), findsOneWidget);
    expect(find.text('Member'), findsOneWidget);
  });

  test('event RSVPs and prayer support toggle locally', () {
    final store = ChurchStore();
    final event = store.module('events').items.first;
    final prayer = store.module('prayers').items.first;
    final initialRsvps = event.count;
    final initialSupport = prayer.count;

    store.toggleRsvp(event);
    store.supportPrayer(prayer);

    expect(event.joined, isTrue);
    expect(event.count, initialRsvps + 1);
    expect(prayer.supported, isTrue);
    expect(prayer.count, initialSupport + 1);

    store.toggleRsvp(event);
    store.supportPrayer(prayer);
    expect(event.count, initialRsvps);
    expect(prayer.count, initialSupport);
  });
}
