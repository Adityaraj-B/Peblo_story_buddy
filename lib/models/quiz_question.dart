class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final question = (json['question'] as String? ?? '').trim();
    final answer = (json['answer'] as String? ?? '').trim();
    final rawOptions = json['options'];

    if (question.isEmpty) {
      throw const FormatException('Quiz question is missing.');
    }

    if (answer.isEmpty) {
      throw const FormatException('Quiz answer is missing.');
    }

    if (rawOptions is! List) {
      throw const FormatException('Quiz options must be a list.');
    }

    final options = rawOptions
        .map((option) => option.toString().trim())
        .where((option) => option.isNotEmpty)
        .toList(growable: false);

    if (options.isEmpty) {
      throw const FormatException('Quiz must include at least one option.');
    }

    if (!options.contains(answer)) {
      throw const FormatException('Quiz answer must match one option.');
    }

    return QuizQuestion(question: question, options: options, answer: answer);
  }

  final String question;
  final List<String> options;
  final String answer;

  bool isCorrect(String option) => option == answer;
}
