class GetPerformanceModel {
  GetPerformanceModel({
    this.studentId,
    this.studentName,
    this.percentage,
    this.studentGrade,
    this.totalHoursSpent,
    this.finalComment,
    this.totalTestTaken,
    this.totalTests,
  });

  GetPerformanceModel.fromJson(dynamic json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    percentage = json['percentage'];
    studentGrade = json['studentGrade'];
    totalHoursSpent = json['totalHoursSpent'];
    finalComment = json['finalComment'];
    totalTestTaken = json['totalTestTaken'];
    totalTests = json['totalTests'];
  }
  int? studentId;
  String? studentName;
  double? percentage;
  String? studentGrade;
  String? totalHoursSpent;
  String? finalComment;
  int? totalTestTaken;
  int? totalTests;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentId'] = studentId;
    map['studentName'] = studentName;
    map['percentage'] = percentage;
    map['studentGrade'] = studentGrade;
    map['totalHoursSpent'] = totalHoursSpent;
    map['finalComment'] = finalComment;
    map['totalTestTaken'] = totalTestTaken;
    map['totalTests'] = totalTests;
    return map;
  }
}
