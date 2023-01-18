class GetNotificationModel {
  GetNotificationModel({
    this.noticeId,
    this.noticeDate,
    this.noticeTime,
    this.content,
    this.institute,
  });

  GetNotificationModel.fromJson(dynamic json) {
    noticeId = json['noticeId'];
    noticeDate = json['noticeDate'];
    noticeTime = json['noticeTime'];
    content = json['content'];
    institute = json['institute'];
  }
  int? noticeId;
  String? noticeDate;
  String? noticeTime;
  String? content;
  int? institute;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['noticeId'] = noticeId;
    map['noticeDate'] = noticeDate;
    map['noticeTime'] = noticeTime;
    map['content'] = content;
    map['institute'] = institute;
    return map;
  }
}
