# Peblo Story Buddy

A lightweight Flutter implementation of Peblo's AI Story Buddy challenge. The app reads a short Pip the Robot story aloud with native text-to-speech, then reveals a JSON-driven quiz with playful feedback.

## Framework Choice

I chose Flutter because the challenge calls out mid-range Android devices and Flutter gives one codebase with a highly controllable animation and rendering layer. The implementation uses Material 3, BLoC/Cubit via `flutter_bloc`, native device TTS through `flutter_tts`, and a small `confetti` package for the celebration.

## State Transition

`StoryBuddyCubit` owns the narration and quiz state with an immutable `StoryBuddyState`:

- `idle`: story is ready.
- `preparing`: TTS settings are being prepared.
- `speaking`: native TTS is narrating the story.
- `completed`: narration has finished and the quiz is revealed.
- `failed`: TTS could not start or complete, so a friendly retry message is shown.

The controller awaits `NarrationPlayer.speak(...)`. In production this is backed by `FlutterTtsNarrationPlayer`, which enables `awaitSpeakCompletion(true)`, so the quiz only appears after narration ends.

## Data-Driven Quiz

The quiz is created from `storyQuizJson` in `lib/data/story_content.dart`:

```json
{
  "question": "What colour was Pip the Robot's lost gear?",
  "options": ["Red", "Green", "Blue", "Yellow"],
  "answer": "Blue"
}
```

`QuizQuestion.fromJson(...)` validates the payload and the UI renders `question.options` with a loop. A backend can send 3, 4, or 5 options without requiring widget changes.

## Audio Loading And Failure States

The main button changes across states:

- `Preparing...` while TTS is configured.
- `Reading...` while narration is active.
- `Try Story Again` after a failure.

Failures are caught in the controller and shown as a retryable message instead of letting the app hang.

## Caching Approach

This version uses native TTS, so there is no remote audio file to cache. If Peblo switched to remote audio, I would cache the generated audio by a stable key made from story text, voice id, language, pitch, and speech rate. Cached files should live in the app documents/cache directory with an expiry policy and a small max-size cleanup to stay friendly on 3GB RAM Android devices.

## Performance Notes

I kept the app lightweight by:

- Avoiding raster image assets and large Lottie files.
- Using one focused Cubit for audio, quiz, and animation trigger state.
- Keeping animations local: shake uses a single `AnimationController`, confetti only runs on success, and UI transitions use short `AnimatedSwitcher` / `AnimatedContainer` animations.
- Rendering quiz options from simple widgets with stable heights to avoid layout jumps.

Recommended profiling before submission:

1. Run `flutter run --profile`.
2. Open Flutter DevTools Performance view.
3. Record the full flow: story start, quiz reveal, wrong answer, success.
4. Capture frame timings and confirm the UI thread and raster thread remain under the 16ms frame budget during shake and confetti.


## Running The App

```bash
flutter pub get
flutter run
```

## Tests

```bash
flutter test
```

## Verification Completed

- `flutter analyze` - no issues found.
- `flutter test` - widget tests passed for narration completion, quiz rendering, wrong answer, and success.
- `flutter build apk --debug` - built `build/app/outputs/flutter-apk/app-debug.apk`.
- Flutter web smoke test at `http://127.0.0.1:43123` - visually checked story screen, reading state, quiz reveal, wrong-answer feedback, and success confetti.
