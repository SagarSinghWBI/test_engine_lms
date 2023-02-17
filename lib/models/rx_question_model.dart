import 'package:get/get.dart';

class RxQuestionModel {
  int questionId;
  String question;
  String questionExpression;
  String option1;
  String expression1;
  String option2;
  String expression2;
  String option3;
  String expression3;
  String option4;
  String expression4;
  String correctOpt;
  String correctExpression;
  String description;
  int testfield;

  RxQuestionModel(
      {required this.questionId,
      required this.question,
      required this.questionExpression,
      required this.option1,
      required this.expression1,
      required this.option2,
      required this.expression2,
      required this.option3,
      required this.expression3,
      required this.option4,
      required this.expression4,
      required this.correctOpt,
      required this.correctExpression,
      required this.description,
      required this.testfield});
}
