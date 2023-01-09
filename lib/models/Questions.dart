class Questions {
  Questions({
    this.question,
    this.questionExpression,
    this.option1,
    this.expression1,
    this.option2,
    this.expression2,
    this.option3,
    this.expression3,
    this.option4,
    this.expression4,
    this.correctOpt,
    this.description,
  });

  Questions.fromJson(dynamic json) {
    question = json['question'];
    questionExpression = json['questionExpression'];
    option1 = json['option1'];
    expression1 = json['expression1'];
    option2 = json['option2'];
    expression2 = json['expression2'];
    option3 = json['option3'];
    expression3 = json['expression3'];
    option4 = json['option4'];
    expression4 = json['expression4'];
    correctOpt = json['correctOpt'];
    description = json['description'];
  }
  String? question;
  String? questionExpression;
  String? option1;
  String? expression1;
  String? option2;
  String? expression2;
  String? option3;
  String? expression3;
  String? option4;
  String? expression4;
  String? correctOpt;
  String? description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question'] = question;
    map['questionExpression'] = questionExpression;
    map['option1'] = option1;
    map['expression1'] = expression1;
    map['option2'] = option2;
    map['expression2'] = expression2;
    map['option3'] = option3;
    map['expression3'] = expression3;
    map['option4'] = option4;
    map['expression4'] = expression4;
    map['correctOpt'] = correctOpt;
    map['description'] = description;
    return map;
  }
}
