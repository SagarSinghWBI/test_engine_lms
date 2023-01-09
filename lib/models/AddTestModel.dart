import 'Teacher.dart';
import 'Course.dart';
import 'Questions.dart';

class AddTestModel {
  AddTestModel({
    this.testName,
    this.startDate,
    this.endDate,
    this.totalQuestions,
    this.totalTime,
    this.teacher,
    this.course,
    this.questions,
  });

  AddTestModel.fromJson(dynamic json) {
    testName = json['testName'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    totalQuestions = json['totalQuestions'];
    totalTime = json['totalTime'];
    teacher =
        json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null;
    course = json['course'] != null ? Course.fromJson(json['course']) : null;
    if (json['questions'] != null) {
      questions = [];
      json['questions'].forEach((v) {
        questions?.add(v);
      });
    }
  }
  String? testName;
  String? startDate;
  String? endDate;
  int? totalQuestions;
  int? totalTime;
  Teacher? teacher;
  Course? course;
  List<Questions>? questions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['testName'] = testName;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['totalQuestions'] = totalQuestions;
    map['totalTime'] = totalTime;
    final teacher = this.teacher;
    if (teacher != null) {
      map['teacher'] = teacher.toJson();
    }
    final course = this.course;
    if (course != null) {
      map['course'] = course.toJson();
    }
    final questions = this.questions;
    if (questions != null) {
      map['questions'] = questions.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
