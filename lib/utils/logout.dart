import '../ui/base/libraryExport.dart';

class Logout {
  final BuildContext context;

  Logout(this.context);

  void awesomeDialog(KonnectDetails details) async {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Logout',
        desc: 'Logout',
        body: Text(
          'Are you sure want to logout',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        btnCancelOnPress: () {},
        btnCancelText: 'Cancel',
        btnOkText: 'Logout',
        btnOkOnPress: () async {
          String key = AppConstants.USER_LOGIN_CREDENTIAL;
          String key1=AppConstants.USER_CART_DATA;
          var credential = await AppPreferences.getString(key);
          UserLogin login = UserLogin.formJson(credential);

          // Logout API
          Map params = Map();
          params['loginId'] = login.loginId;
          await ApiClient().checkedLogOut(params);

          // Set null value
          UserLogin login1 = UserLogin.formJson(null);
          String json = jsonEncode(login1.toJson());
          AppPreferences.setString(key, json);
          AppPreferences.remove(key1);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => DashboardScreen(details),
              ),
              (Route<dynamic> route) => false);
          // End all
        }).show();
  }
}
