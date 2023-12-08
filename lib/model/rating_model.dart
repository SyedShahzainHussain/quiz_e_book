class RatingModel {
  String? sId;
  List<UserId>? userId;
  String? message;
  dynamic rating;
  String? createdAt;
  int? iV;

  RatingModel(
      {this.sId,
      this.userId,
      this.message,
      this.rating,
      this.createdAt,
      this.iV});

  RatingModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['userId'] != null) {
      userId = <UserId>[];
      json['userId'].forEach((v) {
        userId!.add( UserId.fromJson(v));
      });
    }
    message = json['message'];
    rating = json['rating'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['userId'] = this.userId!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['rating'] = this.rating;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class UserId {
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

  UserId(
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

  UserId.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['username'] = username;
    data['email'] = email;
    data['dob'] = dob;
    data['profilePhoto'] = profilePhoto;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['role'] = role;
    data['id'] = id;
    return data;
  }
}
