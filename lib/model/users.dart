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

  Users(
      {this.sId,
      this.username,
      this.email,
      this.dob,
      this.profilePhoto,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.role,
      this.id});

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
  }


}
