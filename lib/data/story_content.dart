import '../models/quiz_question.dart';

const storyText =
    "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods. "
    "The gear was not just any gear - it helped his tiny heart-light glow whenever he learned something new. "
    "Pip rolled past giggling mushrooms, sleepy fireflies, and a wise old banyan tree that whispered, "
    "'Look closely, little friend. The woods hide clues for careful eyes.' ";

const storyQuizJson = <String, dynamic>{
  'question': "What colour was Pip the Robot's lost gear?",
  'options': ['Red', 'Green', 'Blue', 'Yellow'],
  'answer': 'Blue',
};

final pipQuizQuestion = QuizQuestion.fromJson(storyQuizJson);
