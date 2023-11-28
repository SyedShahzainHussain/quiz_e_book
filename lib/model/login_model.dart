class LoginData {
  String? sId;
  String? username;
  String? email;
  String? dob;
  String? profilePhoto;
  String? token;

  LoginData({
    this.sId,
    this.username,
    this.email,
    this.dob,
    this.profilePhoto,
    this.token,
  }); 
  
  LoginData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    email = json['email'];
    dob = json['dob'];
    profilePhoto = json['profilePhoto'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['username'] = username;
    data['email'] = email;
    data['dob'] = dob;
    data['profilePhoto'] = profilePhoto;
    data['token'] = token;
    return data;
  }
}
