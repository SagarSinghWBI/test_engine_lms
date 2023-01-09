class GroupCategoryModel {
  GroupCategoryModel({
    this.categoryId,
    this.categoryName,
    this.institute,
  });

  GroupCategoryModel.fromJson(dynamic json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    institute = json['institute'];
  }
  int? categoryId;
  String? categoryName;
  int? institute;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['categoryId'] = categoryId;
    map['categoryName'] = categoryName;
    map['institute'] = institute;
    return map;
  }
}
