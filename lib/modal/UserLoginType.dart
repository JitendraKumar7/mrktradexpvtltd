import 'dart:convert';

enum UserType {
  SUPER,
  ADMIN,
  MASTER,
  LINKED,
  OFF,
}

class UserLogin {
  UserType _userType = UserType.OFF;
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  UserType get userType => _userType;

  bool get isSuper => userType == UserType.SUPER;

  bool get isAdmin => userType == UserType.ADMIN;

  bool get isMaster => userType == UserType.MASTER;

  bool get isLinked => userType == UserType.LINKED;

  UserLogin(this._userType, this._isLogin);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map();
    data['userType'] = userType.toString();
    data['isLogin'] = isLogin;
    return data;
  }

  UserType getUserType(String statusAsString) {
    for (UserType element in UserType.values) {
      print('UserAsString ' + element.toString());
      print('UserAsString ' + statusAsString);
      if (element.toString() == statusAsString) {
        return element;
      }
    }
    return UserType.OFF;
  }

  UserLogin.formJson(String credential) {
    if (credential != null) {
      Map<String, dynamic> json = jsonDecode(credential);
      if (json['userType'] != null) _userType = getUserType(json['userType']);
      if (json['isLogin'] != null) _isLogin = json['isLogin'];
    } else {
      _userType = UserType.OFF;
      _isLogin = false;
    }
  }
}
