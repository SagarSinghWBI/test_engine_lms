class Teacher {
  Teacher({
      this.userID,});

  Teacher.fromJson(dynamic json) {
    userID = json['userID'];
  }
  int? userID;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userID'] = userID;
    return map;
  }

}