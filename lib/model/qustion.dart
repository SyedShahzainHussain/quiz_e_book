class Question {
  String? sId;
  String? level;
  String? id;
  String? question;
  List<String>? options;
  String? answer;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Question(
      {this.sId,
      this.level,
      this.id,
      this.question,
      this.options,
      this.answer,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Question.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    level = json['level'];
    id = json['id'];
    question = json['question'];
    options = json['options'].cast<String>();
    answer = json['answer'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['level'] = this.level;
    data['id'] = this.id;
    data['question'] = this.question;
    data['options'] = this.options;
    data['answer'] = this.answer;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}