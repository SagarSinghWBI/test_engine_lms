import 'GroupCourse.dart';

class GetStudentsModel {
  GetStudentsModel({
    this.studentId,
    this.userName,
    this.password,
    this.mobile,
    this.email,
    this.studentStatus,
    this.imagePath,
    this.imageName,
    this.registrationDate,
    this.institute,
    this.groupCourse,
  });

  GetStudentsModel.fromJson(dynamic json) {
    studentId = json['studentId'];
    userName = json['userName'];
    password = json['password'];
    mobile = json['mobile'];
    email = json['email'];
    studentStatus = json['studentStatus'];
    imagePath = json['imagePath'];
    imageName = json['imageName'];
    registrationDate = json['registrationDate'];
    institute = json['institute'];
    if (json['groupCourse'] != null) {
      groupCourse = [];
      json['groupCourse'].forEach((v) {
        groupCourse?.add(GroupCourse.fromJson(v));
      });
    }
  }
  int? studentId;
  String? userName;
  String? password;
  String? mobile;
  String? email;
  bool? studentStatus;
  String? imagePath;
  String? imageName;
  String? registrationDate;
  int? institute;
  List<GroupCourse>? groupCourse;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentId'] = studentId;
    map['userName'] = userName;
    map['password'] = password;
    map['mobile'] = mobile;
    map['email'] = email;
    map['studentStatus'] = studentStatus;
    map['imagePath'] = imagePath;
    map['imageName'] = imageName;
    map['registrationDate'] = registrationDate;
    map['institute'] = institute;
    final groupCourse = this.groupCourse;
    if (groupCourse != null) {
      map['groupCourse'] = groupCourse.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
