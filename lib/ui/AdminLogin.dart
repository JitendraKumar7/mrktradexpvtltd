import './base/libraryExport.dart';

class RadioModel {
  UserType type;
  bool isSelected;
  final String label;

  bool get isSuper => type == UserType.SUPER;

  bool get isAdmin => type == UserType.ADMIN;

  bool get isLinked => type == UserType.LINKED;

  RadioModel(this.type, this.isSelected, this.label);
}

class AdminLoginScreen extends StatefulWidget {
  final String logo;

  const AdminLoginScreen({Key key, @required this.logo}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLoginScreen> {
  TextEditingController _password = TextEditingController();
  TextEditingController _loginId = TextEditingController();
  List<RadioModel> loginList = List<RadioModel>();
  RadioModel modal = RadioModel(UserType.LINKED, true, '');
bool _passwordVisible;
  @override
  void initState() {
    _passwordVisible=false;
    super.initState();
    loginList.add(RadioModel(UserType.LINKED, true, 'Link User'));
    loginList.add(RadioModel(UserType.ADMIN, false, 'Co Admin'));
    loginList.add(RadioModel(UserType.SUPER, false, 'Admin'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Login'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              border: Border.all(color: Colors.grey.shade50, width: 1),
              borderRadius: BorderRadius.circular(12.0)),
          width: MediaQuery.of(context).size.width,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Center(
                child: GFImageOverlay(
                  width: 120,
                  height: 80,
                  shape: BoxShape.rectangle,
                  image: NetworkImage(widget.logo),
                ),
              ),
              SizedBox(height: 48.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: loginList.length,
                itemBuilder: (BuildContext context, int index) {
                  final RadioModel _item = loginList[index];
                  return InkWell(
                    //highlightColor: Colors.red,
                    splashColor: Colors.blueAccent,
                    onTap: () {
                      setState(() {
                        loginList.forEach((e) => e.isSelected = false);
                        loginList[index].isSelected = true;
                        modal = _item;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(6.0),
                      child: Container(
                        height: 30.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: Text(
                                _item.label,
                                style: TextStyle(
                                    color: _item.isSelected
                                        ? Colors.black
                                        : Colors.black,
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                            Container(
                              height: 30.0,
                              width: 30.0,
                              child: Center(
                                child: Icon(
                                  Icons.check_circle,
                                  color: _item.isSelected
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  //fontWeight: FontWe
                                ),
                              ),
                            )
                          ],
                        ),
                        /*decoration: BoxDecoration(
                          color: _item.isSelected
                              ? Colors.transparent
                              : Colors.transparent,
                          border: Border.all(
                              width: 1.0,
                              color: _item.isSelected
                                  ? Colors.blueAccent
                                  : Colors.grey),
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(2.0)),
                        ),*/
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 24.0),
              TextFormField(
                maxLength: 10,
                autofocus: false,
                controller: _loginId,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Phone Number',
                  prefixIcon: Icon(Icons.perm_phone_msg),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                ),
              ),
              SizedBox(height: 24.0),
              TextFormField(
                autofocus: false,
                obscureText:!_passwordVisible,
                controller: _password,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon:IconButton (icon:Icon(_passwordVisible?Icons.visibility:Icons.visibility_off,color: Colors.pink,),onPressed: (){
                    setState(() {
                      _passwordVisible=!_passwordVisible;
                    });
                  }, ),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                ),
              ),
              SizedBox(height: 48.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: MaterialButton(
                  onPressed: () {
                    String loginId = _loginId.text;
                    String password = _password.text;
                    if (loginId.length == 10 && password.length > 3) {
                      superLogin(loginId, password);
                    }
                    // Login Id wrong
                    else {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.SCALE,
                        dialogType: DialogType.ERROR,
                        title: 'This is Ignored',
                        desc: 'This is also Ignored',
                        body: Text(
                          'Params wrong',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        dismissOnTouchOutside: false,
                        btnOkOnPress: () {},
                      ).show();
                    }
                  },
                  height: 55,
                  color: Colors.blue.shade300,
                  padding: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  saveCredential(Map response, Map values) {
    if (response['status'] == '200') {
      print('User Login ${response['result']}');
      Map<String, dynamic> result = response['result'];

      values['name'] = '${result['firstname']} ${result['lastname']}';
      values['id'] = result['id'];
      values['email'] = '';
      values['image'] = '';

      print(values);

      String key1 = AppConstants.USER_LOGIN_DATA;
      UserAdmin profile = UserAdmin.fromJson(values);
      AppPreferences.setString(key1, jsonEncode(profile.toJson()));

      String key2 = AppConstants.USER_LOGIN_CREDENTIAL;
      UserLogin login = UserLogin(modal.type, profile.contact);
      AppPreferences.setString(key2, jsonEncode(login.toJson()));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => SplashScreen(),
        ),
      );
    } else {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        body: Text(
          response['message'] ?? '',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        dismissOnTouchOutside: false,
        btnOkOnPress: () {},
      ).show();
    }
  }

  superLogin(String mobile, String password) {
    ProgressDialog dialog = ProgressDialog(context, isDismissible: true);
    dialog.show();

    Map<String, dynamic> values = Map<String, dynamic>();
    values['password'] = password;
    values['contact'] = mobile;

    if (modal.isSuper)
      ApiAdmin().login(mobile, password).then((value) => {
            setState(() {
              dialog.hide();
              print('Admin ${value.data}');
              if (dialog.isShowing()) dialog.hide();
              saveCredential(value.data, values);
            })
          });
    if (modal.isAdmin)
      ApiAdmin().coAdminLogin(mobile, password).then((value) => {
            setState(() {
              dialog.hide();
              print('Co Admin ${value.data}');
              if (dialog.isShowing()) dialog.hide();
              saveCredential(value.data, values);
            })
          });
    if (modal.isLinked)
      ApiAdmin().linkUserLogin(mobile, password).then((value) => {
            setState(() {
              dialog.hide();
              print('Link User ${value.data}');
              if (dialog.isShowing()) dialog.hide();
              saveCredential(value.data, values);
            })
          });
  }
}
