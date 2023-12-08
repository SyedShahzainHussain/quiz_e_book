class ContactModel {
  String? sId;
  String? name;
  String? email;
  String? message;
  int? iV;

  ContactModel({this.sId, this.name, this.email, this.message, this.iV});

  ContactModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    message = json['message'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['message'] = message;
    data['__v'] = iV;
    return data;
  }
}
