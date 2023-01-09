class GetStudentsModel {
  GetStudentsModel({
    this.studentId,
    this.studentName,
    this.email,
    this.mobile,
    this.state,
    this.country,
    this.description,
    this.optCoursesNames,
    this.courses,
  });

  GetStudentsModel.fromJson(dynamic json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    email = json['email'];
    mobile = json['mobile'];
    state = json['state'];
    country = json['country'];
    description = json['description'];
    optCoursesNames = json['optCoursesNames'] != null
        ? json['optCoursesNames'].cast<String>()
        : [];
    if (json['courses'] != null) {
      courses = [];
      json['courses'].forEach((v) {
        courses?.add(v);
      });
    }
  }
  int? studentId;
  String? studentName;
  String? email;
  String? mobile;
  String? state;
  String? country;
  String? description;
  List<dynamic>? optCoursesNames;
  List<dynamic>? courses;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentId'] = studentId;
    map['studentName'] = studentName;
    map['email'] = email;
    map['mobile'] = mobile;
    map['state'] = state;
    map['country'] = country;
    map['description'] = description;
    map['optCoursesNames'] = optCoursesNames;
    final courses = this.courses;
    if (courses != null) {
      map['courses'] = courses.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
