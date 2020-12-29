class UserProfile {

  int _id;
  String _name;
  String _city;
  String _state;
  String _phone;
  String _email;
  String _gstIn;
  String _image;
  String _country;
  String _password;
  String _address1;
  String _address2;
  String _address3;

  int get id => _id;

  String get name => _name;

  String get email => _email;

  String get phone => _phone;

  String get gstIn => _gstIn;

  String get image => _image;

  String get password => _password;

  String get address =>
      '$_address1 $_address2 $_address3 $_city $_state $_country';

  UserProfile.fromJson(Map json) {
    _phone = json['contact_number'];
    _id = json['party_master_id'];
    _address1 = json['address1'];
    _address2 = json['address2'];
    _address3 = json['address3'];
    _password = json['password'];
    _country = json['country'];
    _email = json['email'];
    _gstIn = json['gstin'];
    _image = json['image'];
    _state = json['state'];
    _city = json['city'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map data = new Map<String, dynamic>();
    data['confirm_password'] = this._password;
    data['contact_number'] = this._phone;
    data['password'] = this._password;
    data['party_master_id'] = this._id;
    data['address1'] = this._address1;
    data['address2'] = this._address2;
    data['address3'] = this._address3;
    data['country'] = this._country;
    data['email'] = this._email;
    data['gstin'] = this._gstIn;
    data['image'] = this._image;
    data['state'] = this._state;
    data['city'] = this._city;
    data['name'] = this._name;
    data['id'] = this._id;
    return data;
  }
}
