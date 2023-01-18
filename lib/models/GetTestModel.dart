import 'Questions.dart';

class GetTestModel {
  GetTestModel({
    this.testId,
    this.testName,
    this.startDate,
    this.endDate,
    this.totalQuestions,
    this.totalMarks,
    this.totalTime,
    this.showedQuestion,
    this.groupCourse,
    this.questions,
  });

  GetTestModel.fromJson(dynamic json) {
    testId = json['testId'];
    testName = json['testName'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    totalQuestions = json['totalQuestions'];
    totalMarks = json['totalMarks'];
    totalTime = json['totalTime'];
    showedQuestion = json['showedQuestion'];
    groupCourse = json['groupCourse'];
    if (json['questions'] != null) {
      questions = [];
      json['questions'].forEach((v) {
        questions?.add(Questions.fromJson(v));
      });
    }
  }
  int? testId;
  String? testName;
  String? startDate;
  String? endDate;
  int? totalQuestions;
  int? totalMarks;
  int? totalTime;
  int? showedQuestion;
  int? groupCourse;
  List<Questions>? questions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['testId'] = testId;
    map['testName'] = testName;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['totalQuestions'] = totalQuestions;
    map['totalMarks'] = totalMarks;
    map['totalTime'] = totalTime;
    map['showedQuestion'] = showedQuestion;
    map['groupCourse'] = groupCourse;
    final questions = this.questions;
    if (questions != null) {
      map['questions'] = questions.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
