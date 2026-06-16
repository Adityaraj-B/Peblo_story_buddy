import 'package:flutter_test/flutter_test.dart';
import 'package:peblo_story_buddy/main.dart';
import 'package:peblo_story_buddy/services/narration_player.dart';

void main() {
  testWidgets('reveals the data-driven quiz after narration completes', (
    tester,
  ) async {
    final player = _FakeNarrationPlayer();

    await tester.pumpWidget(PebloStoryBuddyApp(narrationPlayer: player));

    expect(find.text('Read Me a Story'), findsOneWidget);
    expect(
      find.text("What colour was Pip the Robot's lost gear?"),
      findsNothing,
    );

    await tester.tap(find.text('Read Me a Story'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(player.spokenText, contains('Pip lost his shiny blue gear'));
    expect(player.spokenText, contains('staying curious and brave'));
    expect(
      find.text("What colour was Pip the Robot's lost gear?"),
      findsOneWidget,
    );
    expect(find.text('Red'), findsOneWidget);
    expect(find.text('Green'), findsOneWidget);
    expect(find.text('Blue'), findsOneWidget);
    expect(find.text('Yellow'), findsOneWidget);
  });

  testWidgets('wrong answer shakes and correct answer shows success', (
    tester,
  ) async {
    final player = _FakeNarrationPlayer();

    await tester.pumpWidget(PebloStoryBuddyApp(narrationPlayer: player));
    await tester.tap(find.text('Read Me a Story'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Red'));
    await tester.tap(find.text('Red'));
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.text('Almost! Try another colour.'), findsOneWidget);

    await tester.ensureVisible(find.text('Blue'));
    await tester.tap(find.text('Blue'));
    await tester.pump();

    expect(
      find.text('Success! Pip found the shiny blue gear.'),
      findsOneWidget,
    );
  });
}

class _FakeNarrationPlayer implements NarrationPlayer {
  String spokenText = '';

  @override
  Future<void> speak(String text) async {
    spokenText = text;
  }

  @override
  Future<void> stop() async {}
}
