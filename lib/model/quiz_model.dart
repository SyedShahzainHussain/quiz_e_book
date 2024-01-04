class Quiz {
  String? id;
  String? image;
  String? title;
  String? level;
  bool isLoacked = true;

  Quiz({
    required this.id,
    required this.image,
    required this.level,
    required this.isLoacked,
    required this.title,

  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['id'] = id;
    json['image'] = image;
    json['level'] = level;
    json['isLoacked'] = isLoacked;
    json['title'] = title;
    return json;
  }

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    level = json['level'];
    isLoacked = json['isLoacked'];
    title = json['title'];
  }
}
