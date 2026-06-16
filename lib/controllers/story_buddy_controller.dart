import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../data/story_content.dart';
import '../models/quiz_question.dart';
import '../services/narration_player.dart';

enum NarrationPhase { idle, preparing, speaking, completed, failed }

class StoryBuddyState {
  const StoryBuddyState({
    required this.phase,
    required this.quiz,
    required this.quizVisible,
    required this.answeredCorrectly,
    required this.shakeTick,
    this.selectedOption,
    this.errorMessage,
  });

  factory StoryBuddyState.initial(QuizQuestion quiz) {
    return StoryBuddyState(
      phase: NarrationPhase.idle,
      quiz: quiz,
      quizVisible: false,
      answeredCorrectly: false,
      shakeTick: 0,
    );
  }

  static const _unset = Object();

  final NarrationPhase phase;
  final QuizQuestion quiz;
  final String? selectedOption;
  final String? errorMessage;
  final bool quizVisible;
  final bool answeredCorrectly;
  final int shakeTick;

  bool get isBusy =>
      phase == NarrationPhase.preparing || phase == NarrationPhase.speaking;

  StoryBuddyState copyWith({
    NarrationPhase? phase,
    Object? selectedOption = _unset,
    Object? errorMessage = _unset,
    bool? quizVisible,
    bool? answeredCorrectly,
    int? shakeTick,
  }) {
    return StoryBuddyState(
      phase: phase ?? this.phase,
      quiz: quiz,
      selectedOption: selectedOption == _unset
          ? this.selectedOption
          : selectedOption as String?,
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
      quizVisible: quizVisible ?? this.quizVisible,
      answeredCorrectly: answeredCorrectly ?? this.answeredCorrectly,
      shakeTick: shakeTick ?? this.shakeTick,
    );
  }
}

class StoryBuddyCubit extends Cubit<StoryBuddyState> {
  StoryBuddyCubit({NarrationPlayer? narrationPlayer})
    : _narrationPlayer = narrationPlayer ?? FlutterTtsNarrationPlayer(),
      super(StoryBuddyState.initial(pipQuizQuestion));

  final NarrationPlayer _narrationPlayer;

  Future<void> playStory() async {
    if (state.isBusy) {
      return;
    }

    _emitSafely(
      state.copyWith(
        phase: NarrationPhase.preparing,
        errorMessage: null,
        quizVisible: false,
        selectedOption: null,
        answeredCorrectly: false,
      ),
    );

    try {
      await _narrationPlayer.stop();
      _emitSafely(state.copyWith(phase: NarrationPhase.speaking));

      await _narrationPlayer.speak(storyText);

      _emitSafely(
        state.copyWith(phase: NarrationPhase.completed, quizVisible: true),
      );
    } catch (_) {
      _emitSafely(
        state.copyWith(
          phase: NarrationPhase.failed,
          quizVisible: false,
          errorMessage:
              'Pip could not read the story right now. Please try again.',
        ),
      );
    }
  }

  void chooseOption(String option) {
    if (!state.quizVisible || state.answeredCorrectly) {
      return;
    }

    if (state.quiz.isCorrect(option)) {
      unawaited(HapticFeedback.heavyImpact());
      _emitSafely(
        state.copyWith(selectedOption: option, answeredCorrectly: true),
      );
    } else {
      unawaited(HapticFeedback.mediumImpact());
      _emitSafely(
        state.copyWith(selectedOption: option, shakeTick: state.shakeTick + 1),
      );
    }
  }

  void _emitSafely(StoryBuddyState nextState) {
    if (!isClosed) {
      emit(nextState);
    }
  }

  @override
  Future<void> close() {
    unawaited(_narrationPlayer.stop());
    return super.close();
  }
}
