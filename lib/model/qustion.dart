class Question {
  int? id, answer;
  String? question;
  List<String>? options;
  String? level;

  Question({this.id, this.question, this.answer, this.options, this.level});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map<String, dynamic>();
    json['id'] = id;
    json['answer'] = answer;
    json['question'] = question;
    json['options'] = options;
    json['level'] = level;
    return json;
  }

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answer = json['answer'];
    question = json['question'];
    options = (json['options'] as List<dynamic>?)
        ?.where((option) => option is String && option.isNotEmpty)
        .cast<String>()
        .toList();

    level = json['level'];
  }
}
