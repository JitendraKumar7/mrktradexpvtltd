
class UserAdmin {
  int _id;
  String _name;
  String _email;
  String _image;
  String _contact;
  String _password;

  int get id => _id;

  String get name => _name;

  String get email => _email;

  String get image => _image;

  String get contact => _contact;

  String get password => _password;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    data['contact'] = contact;
    data['password'] = password;
    return data;
  }

  UserAdmin.fromJson(Map<String, dynamic> json) {
    _password = json['password'];
    _contact = json['contact'];
    _image = json['image'];
    _email = json['email'];
    _name = json['name'];
    _id = json['id'];
  }
}
