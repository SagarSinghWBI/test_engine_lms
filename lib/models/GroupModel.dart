class GroupModel {
  GroupModel({
    this.groupId,
    this.groupName,
    this.institute,
  });

  GroupModel.fromJson(dynamic json) {
    groupId = json['groupId'];
    groupName = json['groupName'];
    institute = json['institute'];
  }
  int? groupId;
  String? groupName;
  int? institute;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['groupId'] = groupId;
    map['groupName'] = groupName;
    map['institute'] = institute;
    return map;
  }
}
