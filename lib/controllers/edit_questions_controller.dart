import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:test_engine_lms/models/GetTestModel.dart';
import 'package:test_engine_lms/models/rx_question_model.dart';
import 'package:test_engine_lms/utils/constants.dart';
import 'package:test_engine_lms/utils/my_dialogs.dart';

class EditQuestionsController extends GetxController {
  RxList<RxQuestionModel> questionsList = <RxQuestionModel>[].obs;
  List<GlobalKey<FormState>> formKeys =
      List.generate(100, (index) => GlobalKey<FormState>());

  updateQuestionList({required GetTestModel? value}) {
    questionsList.clear();
    for (var element in value!.questions!) {
      questionsList.value.add(RxQuestionModel(
        correctExpression: element.correctExpression.toString(),
        correctOpt: element.correctOpt.toString(),
        expression1: element.expression1.toString(),
        expression2: element.expression2.toString(),
        expression3: element.expression3.toString(),
        expression4: element.expression4.toString(),
        option1: element.option1.toString(),
        option2: element.option2.toString(),
        option3: element.option3.toString(),
        option4: element.option4.toString(),
        question: element.question.toString(),
        questionExpression: element.questionExpression.toString(),
        questionId: int.parse(element.questionId.toString()),
        testfield: int.parse(element.testfield.toString()),
        description: element.description.toString(),
      ));
    }
    refresh();
    update();
    print("Called.............${questionsList[0].option1}");
  }

  updateQuestion({
    required int questionId,
    required void Function() onSuccess,
    required String question,
    required String questionExpression,
    required String option1,
    required String expression1,
    required String option2,
    required String expression2,
    required String option3,
    required String expression3,
    required String option4,
    required String expression4,
    required String correctOpt,
    required String correctExpression,
    required String description,
  }) async {
    var data = json.encode({
      "question": question,
      "questionExpression": questionExpression,
      "option1": option1,
      "expression1": expression1,
      "option2": option2,
      "expression2": expression2,
      "option3": option3,
      "expression3": expression3,
      "option4": option4,
      "expression4": expression4,
      "correctOpt": correctOpt,
      "correctExpression": correctExpression,
      "description": description,
    });
    print("Sending data is: $data");
    getLoadingDialogue(title: "Updating Question...");
    try {
      await dio_package.Dio()
          .put("${Constants.baseUrl}/updateQuestionById/$questionId",
              data: data)
          .then((value) {
        if (value.statusCode == 200) {
          removeDialogue();
          onSuccess.call();
        }
      });
    } catch (e) {
      removeDialogue();
      if (kDebugMode) {
        print("Error while updating question:$e");
      }
      getErrorDialogue(errorMessage: e.toString());
    }
  }
}
