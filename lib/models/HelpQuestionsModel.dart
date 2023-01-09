class HelpQuestionsModel {
  HelpQuestionsModel({
    this.question,
    this.answer,
  });

  HelpQuestionsModel.fromJson(dynamic json) {
    question = json['question'];
    answer = json['answer'];
  }
  String? question;
  String? answer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question'] = question;
    map['answer'] = answer;
    return map;
  }
}
