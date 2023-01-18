class GetStudentsModel {
  GetStudentsModel({
    this.studentId,
    this.userName,
    this.password,
    this.mobile,
    this.email,
    this.imagePath,
    this.imageName,
    this.registrationDate,
    this.institute,
    this.groupCourse,
    this.optcoursesIds,
  });

  GetStudentsModel.fromJson(dynamic json) {
    studentId = json['studentId'];
    userName = json['userName'];
    password = json['password'];
    mobile = json['mobile'];
    email = json['email'];
    imagePath = json['imagePath'];
    imageName = json['imageName'];
    registrationDate = json['registrationDate'];
    institute = json['institute'];
    if (json['groupCourse'] != null) {
      groupCourse = [];
      json['groupCourse'].forEach((v) {
        groupCourse?.add(v);
      });
    }
    if (json['optcoursesIds'] != null) {
      optcoursesIds = [];
      json['optcoursesIds'].forEach((v) {
        optcoursesIds?.add(v);
      });
    }
  }
  int? studentId;
  String? userName;
  String? password;
  String? mobile;
  String? email;
  String? imagePath;
  String? imageName;
  String? registrationDate;
  int? institute;
  List<dynamic>? groupCourse;
  List<dynamic>? optcoursesIds;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentId'] = studentId;
    map['userName'] = userName;
    map['password'] = password;
    map['mobile'] = mobile;
    map['email'] = email;
    map['imagePath'] = imagePath;
    map['imageName'] = imageName;
    map['registrationDate'] = registrationDate;
    map['institute'] = institute;
    final groupCourse = this.groupCourse;
    if (groupCourse != null) {
      map['groupCourse'] = groupCourse.map((v) => v.toJson()).toList();
    }
    final optcoursesIds = this.optcoursesIds;
    if (optcoursesIds != null) {
      map['optcoursesIds'] = optcoursesIds.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
