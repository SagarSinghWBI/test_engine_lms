class HelpModel {
  HelpModel({
      this.helpId, 
      this.helpQuestion, 
      this.helpAnswer,});

  HelpModel.fromJson(dynamic json) {
    helpId = json['helpId'];
    helpQuestion = json['helpQuestion'];
    helpAnswer = json['helpAnswer'];
  }
  String? helpId;
  String? helpQuestion;
  String? helpAnswer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['helpId'] = helpId;
    map['helpQuestion'] = helpQuestion;
    map['helpAnswer'] = helpAnswer;
    return map;
  }

}