class GetNotificationsModel {
  GetNotificationsModel({
    this.notificationId,
    this.notification,
    this.fkCourseId,
    this.instituteId,
    this.teacherId,
    this.studentId,
    this.notificationDate,
    this.notificationTime,
  });

  GetNotificationsModel.fromJson(dynamic json) {
    notificationId = json['notificationId'];
    notification = json['notification'];
    fkCourseId = json['fkCourseId'];
    instituteId = json['instituteId'];
    teacherId = json['teacherId'];
    studentId = json['studentId'];
    notificationDate = json['notificationDate'];
    notificationTime = json['notificationTime'];
  }
  int? notificationId;
  String? notification;
  int? fkCourseId;
  int? instituteId;
  int? teacherId;
  int? studentId;
  String? notificationDate;
  String? notificationTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notificationId'] = notificationId;
    map['notification'] = notification;
    map['fkCourseId'] = fkCourseId;
    map['instituteId'] = instituteId;
    map['teacherId'] = teacherId;
    map['studentId'] = studentId;
    map['notificationDate'] = notificationDate;
    map['notificationTime'] = notificationTime;
    return map;
  }
}
