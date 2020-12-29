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
  String _loginId = '123456789';
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  String get loginId => _loginId;

  UserType get userType => _userType;

  bool get isSuper => userType == UserType.SUPER;

  bool get isAdmin => userType == UserType.ADMIN;

  bool get isMaster => userType == UserType.MASTER;

  bool get isLinked => userType == UserType.LINKED;

  UserLogin(UserType _userType, String _loginId)
      : _userType = _userType,
        _loginId = _loginId,
        _isLogin = true;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map();
    data['userType'] = userType.toString();
    data['isLogin'] = isLogin;
    data['loginId'] = loginId;
    return data;
  }

  UserType getUserType(String status) {
    for (UserType element in UserType.values) {
      print('UserAsString ' + element.toString());
      print('UserAsString ' + status);
      if (element.toString() == status) {
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
      if (json['loginId'] != null) _loginId = json['loginId'];
    } else {
      _userType = UserType.OFF;
      _isLogin = false;
    }
  }
}
