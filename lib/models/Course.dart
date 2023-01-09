class Course {
  Course({
      this.courseId,});

  Course.fromJson(dynamic json) {
    courseId = json['courseId'];
  }
  int? courseId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['courseId'] = courseId;
    return map;
  }

}