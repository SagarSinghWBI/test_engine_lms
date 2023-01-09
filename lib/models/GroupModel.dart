class GroupModel {
  GroupModel({
    this.courseId,
    this.courseName,
    this.description,
    this.startDate,
    this.endDate,
    this.price,
    this.discount,
    this.imageFile,
    this.imageFileName,
    this.category,
    this.teacher,
    this.paid,
  });

  GroupModel.fromJson(dynamic json) {
    courseId = json['courseId'];
    courseName = json['courseName'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    price = json['price'];
    discount = json['discount'];
    imageFile = json['imageFile'];
    imageFileName = json['imageFileName'];
    category = json['category'];
    teacher = json['teacher'];
    paid = json['paid'];
  }
  int? courseId;
  String? courseName;
  String? description;
  String? startDate;
  String? endDate;
  double? price;
  int? discount;
  String? imageFile;
  String? imageFileName;
  String? category;
  String? teacher;
  bool? paid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['courseId'] = courseId;
    map['courseName'] = courseName;
    map['description'] = description;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['price'] = price;
    map['discount'] = discount;
    map['imageFile'] = imageFile;
    map['imageFileName'] = imageFileName;
    map['category'] = category;
    map['teacher'] = teacher;
    map['paid'] = paid;
    return map;
  }
}
