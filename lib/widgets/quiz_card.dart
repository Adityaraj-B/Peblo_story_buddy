import 'package:flutter/material.dart';

import '../models/quiz_question.dart';
import 'shake_transition.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({
    required this.question,
    required this.selectedOption,
    required this.solved,
    required this.shakeTrigger,
    required this.onOptionSelected,
    super.key,
  });

  final QuizQuestion question;
  final String? selectedOption;
  final bool solved;
  final int shakeTrigger;
  final ValueChanged<String> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final showWrongFeedback =
        selectedOption != null &&
        !question.isCorrect(selectedOption!) &&
        !solved;

    return ShakeTransition(
      trigger: shakeTrigger,
      child: Container(
        key: const ValueKey('quiz-card'),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF17324D), width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF17324D).withValues(alpha: 0.14),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBF7FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.psychology_alt_rounded,
                    color: Color(0xFF17324D),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Quiz Time',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              question.question,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            for (final option in question.options) ...[
              _QuizOptionButton(
                option: option,
                isSelected: selectedOption == option,
                isCorrectAnswer: question.isCorrect(option),
                solved: solved,
                onPressed: solved ? null : () => onOptionSelected(option),
              ),
              if (option != question.options.last) const SizedBox(height: 10),
            ],
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: solved
                  ? const _QuizMessage(
                      key: ValueKey('success-message'),
                      icon: Icons.check_circle_rounded,
                      color: Color(0xFF1B9C6B),
                      text: 'Success! Pip found the shiny blue gear.',
                    )
                  : showWrongFeedback
                  ? const _QuizMessage(
                      key: ValueKey('wrong-message'),
                      icon: Icons.replay_rounded,
                      color: Color(0xFFE75A4B),
                      text: 'Almost! Try another colour.',
                    )
                  : const SizedBox.shrink(key: ValueKey('empty-message')),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizOptionButton extends StatelessWidget {
  const _QuizOptionButton({
    required this.option,
    required this.isSelected,
    required this.isCorrectAnswer,
    required this.solved,
    required this.onPressed,
  });

  final String option;
  final bool isSelected;
  final bool isCorrectAnswer;
  final bool solved;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isSuccess = solved && isCorrectAnswer;
    final isWrong = isSelected && !isCorrectAnswer && !solved;
    final backgroundColor = isSuccess
        ? const Color(0xFFE5F8EF)
        : isWrong
        ? const Color(0xFFFFECE8)
        : const Color(0xFFFFFBF1);
    final borderColor = isSuccess
        ? const Color(0xFF1B9C6B)
        : isWrong
        ? const Color(0xFFE75A4B)
        : const Color(0xFFFFB347);

    return Semantics(
      button: true,
      selected: isSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        constraints: const BoxConstraints(minHeight: 58),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      isSuccess
                          ? Icons.check_circle_rounded
                          : isWrong
                          ? Icons.error_rounded
                          : Icons.radio_button_unchecked_rounded,
                      key: ValueKey('$option-$isSuccess-$isWrong'),
                      color: borderColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizMessage extends StatelessWidget {
  const _QuizMessage({
    required this.icon,
    required this.color,
    required this.text,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
