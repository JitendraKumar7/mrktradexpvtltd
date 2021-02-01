import '../../base/libraryExport.dart';

class PartyMasterLoginScreen extends StatefulWidget {
  final String loginId;
  final String logo;

  const PartyMasterLoginScreen({Key key, this.loginId, this.logo})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PartyMasterLoginState();
}

class _PartyMasterLoginState extends State<PartyMasterLoginScreen> {
  TextEditingController _loginId = TextEditingController();
  TextEditingController _password = TextEditingController();
bool passwrdv;
  @override
  void initState() {
    super.initState();
passwrdv=false;
    _loginId.text = widget.loginId;
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
          title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: new BoxDecoration(
              color: Colors.grey.shade300,
              border: new Border.all(color: Colors.grey.shade50, width: 1),
              borderRadius: new BorderRadius.circular(12.0)),
          width: MediaQuery.of(context).size.width,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Center(
                child: GFImageOverlay(
                    width: 120,
                    height: 80,
                    shape: BoxShape.rectangle,
                    image: NetworkImage(widget.logo)),
              ),
              SizedBox(height: 68.0),
              TextFormField(
                autofocus: false,
                controller: _loginId,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'GST or Phone Number',
                  prefixIcon: Icon(Icons.perm_phone_msg),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                ),
              ),
              SizedBox(height: 48.0),
              TextFormField(
                autofocus: true,
                obscureText:!passwrdv,
                controller: _password,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton (icon:Icon(passwrdv?Icons.visibility:Icons.visibility_off,color: Colors.pink,),onPressed: (){
                    setState(() {
                      passwrdv=!passwrdv;
                    });
                  }, ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                ),
              ),
              SizedBox(height: 24.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: MaterialButton(
                  onPressed: () {
                    String loginId = _loginId.text;
                    if (loginId.length > 9) {
                      ProgressDialog dialog =
                          ProgressDialog(context, isDismissible: false);
                      dialog.show();
                      ApiClient().forgetPasswordOtp(loginId).then((value) => {
                            setState(() {
                              dialog.hide();
                              print(value.data);
                              Map<String, dynamic> response = value.data;
                              if (response['status'] == '200') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PartyMasterForgotScreen(
                                      loginId: loginId,
                                      logo: widget.logo,
                                    ),
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
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  dismissOnTouchOutside: false,
                                  btnOkOnPress: () {
                                    dialog.hide();
                                  },
                                ).show();
                              }
                              print(value);
                            })
                          });
                    }
                  },
                  height: 55,
                  elevation: 0,
                  color: Colors.grey.shade300,
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blue.shade300),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: MaterialButton(
                  onPressed: () {
                    String loginId = _loginId.text;
                    String password = _password.text;
                    if (loginId.length > 9 && password.length > 3) {
                      ProgressDialog dialog =
                          ProgressDialog(context, isDismissible: false);
                      dialog.show();
                      ApiClient()
                          .loginPartyMaster(loginId, password)
                          .then((value) => {
                                setState(() {
                                  dialog.hide();
                                  print(value.data);
                                  Map<String, dynamic> response = value.data;
                                  if (response['status'] == '200') {
                                    UserProfile profile = UserProfile.fromJson(
                                        response['result']);

                                    UserLogin login = UserLogin(
                                        UserType.MASTER, profile.phone);

                                    String key1 = AppConstants.USER_LOGIN_DATA;
                                    String key2 =
                                        AppConstants.USER_LOGIN_CREDENTIAL;

                                    AppPreferences.setString(
                                        key2, jsonEncode(login.toJson()));
                                    AppPreferences.setString(
                                        key1, jsonEncode(profile.toJson()));

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SplashScreen(),
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
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      dismissOnTouchOutside: false,
                                      btnOkOnPress: () {
                                        dialog.hide();
                                      },
                                    ).show();
                                  }
                                  print(value);
                                })
                              });
                    }
                  },
                  height: 55,
                  color: Colors.blue.shade300,
                  padding: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Login',
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
}
