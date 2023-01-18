class GroupModel {
  GroupModel({
    this.groupId,
    this.groupName,
    this.institute,
    this.multipleTests,
    this.students,
  });

  GroupModel.fromJson(dynamic json) {
    groupId = json['groupId'];
    groupName = json['groupName'];
    institute = json['institute'];
    if (json['multipleTests'] != null) {
      multipleTests = [];
      json['multipleTests'].forEach((v) {
        multipleTests?.add(v);
      });
    }
    if (json['students'] != null) {
      students = [];
      json['students'].forEach((v) {
        students?.add(v);
      });
    }
  }
  int? groupId;
  String? groupName;
  int? institute;
  List<dynamic>? multipleTests;
  List<dynamic>? students;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['groupId'] = groupId;
    map['groupName'] = groupName;
    map['institute'] = institute;
    final multipleTests = this.multipleTests;
    if (multipleTests != null) {
      map['multipleTests'] = multipleTests.map((v) => v.toJson()).toList();
    }
    final students = this.students;
    if (students != null) {
      map['students'] = students.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
