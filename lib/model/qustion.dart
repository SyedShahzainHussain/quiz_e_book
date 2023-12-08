class Question {
  String? sId; // The ID of the question in the API
  String? level; // The level of the question
  String? id; // Another ID field (not used in your JSON, seems redundant)
  String? question; // The text of the question
  List<String>? options; // List of options for the question
  String? answer; // The correct answer to the question
  String? createdAt; // Timestamp indicating when the question was created
  String? updatedAt; // Timestamp indicating when the question was last updated
  int? iV; // Version number (__v) field in your JSON (used for concurrency control)

  // Constructor for creating a Question object
  Question({
    this.sId,
    this.level,
    this.id,
    this.question,
    this.options,
    this.answer,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  // Factory method for creating a Question object from JSON data
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      sId: json['_id'],
      level: json['level'],
      id: json['id'],
      question: json['question'],
      options: json['options']?.cast<String>(), // Cast options to String list
      answer: json['answer'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
    );
  }

  // Method for converting a Question object to JSON data
  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'level': level,
      'id': id,
      'question': question,
      'options': options,
      'answer': answer,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
    };
  }
}
