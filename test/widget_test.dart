
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moto_travel/main.dart';

void main() {
  testWidgets('Welcome screen displays correctly', (tester) async {
    await tester.pumpWidget(const MotoTravelApp());

    expect(find.text('THE ROAD\nIS YOURS.'), findsOneWidget);
    expect(find.text('MOTO TRAVEL'), findsOneWidget);
    expect(find.textContaining('ENTER GARAGE'), findsOneWidget);
  });

  testWidgets('User can open the motorcycle garage', (tester) async {
    await tester.pumpWidget(const MotoTravelApp());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('ENTER GARAGE'));
    await tester.pumpAndSettle();

    expect(find.text('YOUR GARAGE'), findsOneWidget);
    expect(find.text('CHOOSE YOUR RIDE'), findsOneWidget);
    expect(find.text('Street Rider'), findsOneWidget);
    expect(find.textContaining('START RIDE'), findsOneWidget);
  });

  testWidgets('User can open the ride screen and see controls',
          (tester) async {
        await tester.pumpWidget(const MotoTravelApp());
        await tester.pumpAndSettle();

        await tester.tap(find.textContaining('ENTER GARAGE'));
        await tester.pumpAndSettle();

        // Tap the garage's start button.
        await tester.tap(find.byType(FilledButton).last);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('FREE RIDE'), findsOneWidget);
        expect(find.text('SPEED'), findsOneWidget);
        expect(find.text('DISTANCE'), findsOneWidget);
        expect(find.text('GAS'), findsOneWidget);
        expect(find.text('BRAKE'), findsOneWidget);
        expect(find.text('LEFT'), findsOneWidget);
        expect(find.text('RIGHT'), findsOneWidget);

        // Dispose the screen to stop its periodic timer.
        await tester.pumpWidget(const SizedBox());
        await tester.pump();
      });

  testWidgets('Obstacle-enabled ride runs without exceptions',
          (tester) async {
        await tester.pumpWidget(const MotoTravelApp());
        await tester.pumpAndSettle();

        await tester.tap(find.textContaining('ENTER GARAGE'));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FilledButton).last);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.text('FREE RIDE'), findsOneWidget);

        // Advance the game so the obstacle system updates.
        await tester.pump(const Duration(seconds: 2));

        expect(tester.takeException(), isNull);

        // Stop the game's timer before ending the test.
        await tester.pumpWidget(const SizedBox());
        await tester.pump();
      });
}
