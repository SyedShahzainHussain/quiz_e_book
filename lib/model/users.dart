class Users {
  String? sId;
  String? username;
  String? email;
  String? dob;
  String? profilePhoto;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? role;
  String? id;
  int? scorrer;
  List<dynamic>? unlocked;

  Users({
    this.sId,
    this.username,
    this.email,
    this.dob,
    this.profilePhoto,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.role,
    this.id,
    this.scorrer,
    this.unlocked,
  });

  // Convert the object to a JSON representation
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['_id'] = sId;
    json['username'] = username;
    json['email'] = email;
    json['dob'] = dob;
    json['profilePhoto'] = profilePhoto;
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;
    json['__v'] = iV;
    json['role'] = role;
    json['id'] = id;
    json['scorrer'] = scorrer;
    json['unlocked'] = unlocked;

    return json;
  }

  // Create a Users object from JSON
  Users.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    email = json['email'];
    dob = json['dob'];
    profilePhoto = json['profilePhoto'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    role = json['role'];
    id = json['id'];
    scorrer = json['scorrer'];
    unlocked = json['unlocked'];
  }
}
