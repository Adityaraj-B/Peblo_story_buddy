import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/story_buddy_controller.dart';
import 'buddy_hero.dart';
import 'peblo_backdrop.dart';
import 'quiz_card.dart';
import 'story_card.dart';

class StoryBuddyScreen extends StatelessWidget {
  const StoryBuddyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: PebloBackdrop()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 46,
                    ),
                    child: BlocBuilder<StoryBuddyCubit, StoryBuddyState>(
                      builder: (context, state) {
                        final cubit = context.read<StoryBuddyCubit>();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _Header(phase: state.phase),
                            const SizedBox(height: 16),
                            Text(
                              "Pip's Story Buddy",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    height: 1.05,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'A tiny tale from the Whispering Woods',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 14),
                            BuddyHero(mood: _moodFor(state)),
                            const SizedBox(height: 14),
                            _ReadStoryButton(
                              phase: state.phase,
                              onPressed: state.isBusy ? null : cubit.playStory,
                            ),
                            const SizedBox(height: 16),
                            StoryCard(
                              isReading: state.phase == NarrationPhase.speaking,
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 260),
                              child: state.errorMessage == null
                                  ? const SizedBox.shrink()
                                  : _ErrorBanner(
                                      key: const ValueKey('error-banner'),
                                      message: state.errorMessage!,
                                      onRetry: cubit.playStory,
                                    ),
                            ),
                            const SizedBox(height: 18),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 460),
                              switchInCurve: Curves.easeOutBack,
                              switchOutCurve: Curves.easeIn,
                              child: state.quizVisible
                                  ? QuizCard(
                                      question: state.quiz,
                                      selectedOption: state.selectedOption,
                                      solved: state.answeredCorrectly,
                                      shakeTrigger: state.shakeTick,
                                      onOptionSelected: cubit.chooseOption,
                                    )
                                  : const _QuizPreview(
                                      key: ValueKey('quiz-preview'),
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          BlocSelector<StoryBuddyCubit, StoryBuddyState, bool>(
            selector: (state) => state.answeredCorrectly,
            builder: (context, solved) => _SuccessConfetti(solved: solved),
          ),
        ],
      ),
    );
  }

  BuddyMood _moodFor(StoryBuddyState state) {
    if (state.answeredCorrectly) {
      return BuddyMood.happy;
    }

    return switch (state.phase) {
      NarrationPhase.speaking => BuddyMood.reading,
      NarrationPhase.failed => BuddyMood.worried,
      _ => BuddyMood.ready,
    };
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.phase});

  final NarrationPhase phase;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF17324D), width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6F61),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 15,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Peblo',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
        const Spacer(),
        _StatusPill(phase: phase),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.phase});

  final NarrationPhase phase;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (phase) {
      NarrationPhase.preparing => (
        'Preparing',
        const Color(0xFFFFB347),
        Icons.hourglass_top_rounded,
      ),
      NarrationPhase.speaking => (
        'Reading',
        const Color(0xFF1AA6B7),
        Icons.volume_up_rounded,
      ),
      NarrationPhase.completed => (
        'Quiz',
        const Color(0xFF56C596),
        Icons.quiz_rounded,
      ),
      NarrationPhase.failed => (
        'Retry',
        const Color(0xFFFF6F61),
        Icons.refresh_rounded,
      ),
      NarrationPhase.idle => (
        'Ready',
        const Color(0xFF56C596),
        Icons.play_arrow_rounded,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF17324D), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF17324D)),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: const Color(0xFF17324D),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadStoryButton extends StatelessWidget {
  const _ReadStoryButton({required this.phase, required this.onPressed});

  final NarrationPhase phase;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final label = switch (phase) {
      NarrationPhase.preparing => 'Preparing...',
      NarrationPhase.speaking => 'Reading...',
      NarrationPhase.completed => 'Read Again',
      NarrationPhase.failed => 'Try Story Again',
      NarrationPhase.idle => 'Read Me a Story',
    };

    final busy =
        phase == NarrationPhase.preparing || phase == NarrationPhase.speaking;

    return SizedBox(
      height: 62,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFF6F61),
          foregroundColor: const Color(0xFFFFFFFF),
          disabledBackgroundColor: const Color(0xFFFFB58C),
          disabledForegroundColor: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFF17324D), width: 3),
          ),
          textStyle: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        icon: busy
            ? const SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xFFFFFFFF),
                ),
              )
            : const Icon(Icons.volume_up_rounded, size: 25),
        label: Text(label),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onRetry, super.key});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECE8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE75A4B), width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_rounded, color: Color(0xFFE75A4B)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF7A2D25),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Retry',
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            color: const Color(0xFFE75A4B),
          ),
        ],
      ),
    );
  }
}

class _QuizPreview extends StatelessWidget {
  const _QuizPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF17324D).withValues(alpha: 0.18),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFDBF7FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.lock_open_rounded,
              color: Color(0xFF17324D),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'The quiz appears when Pip finishes reading.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessConfetti extends StatefulWidget {
  const _SuccessConfetti({required this.solved});

  final bool solved;

  @override
  State<_SuccessConfetti> createState() => _SuccessConfettiState();
}

class _SuccessConfettiState extends State<_SuccessConfetti> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 1700),
    );
  }

  @override
  void didUpdateWidget(covariant _SuccessConfetti oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.solved && !oldWidget.solved) {
      _confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          numberOfParticles: 24,
          emissionFrequency: 0.05,
          gravity: 0.42,
          shouldLoop: false,
          colors: const [
            Color(0xFFFF6F61),
            Color(0xFFFFD166),
            Color(0xFF56C596),
            Color(0xFF1AA6B7),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
}
