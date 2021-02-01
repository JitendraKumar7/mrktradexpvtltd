import '../../base/libraryExport.dart';

class PartyMasterRegisterScreen extends StatefulWidget {
  final String loginId;

  PartyMasterRegisterScreen({Key key, this.loginId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PartyMasterRegisterState();
}

class _PartyMasterRegisterState extends State<PartyMasterRegisterScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _mobile1 = TextEditingController();
  TextEditingController _mobile2 = TextEditingController();
  TextEditingController _emailId = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _password1 = TextEditingController();
  TextEditingController _password2 = TextEditingController();
  TextEditingController _gstNumber = TextEditingController();
  bool isGstRequired = false;
  bool _passwordVisible,_passwordVisible1,_passwordVisible2;
  @override
  void initState() {
    super.initState();
    _passwordVisible=false;
    _passwordVisible1=false;
    _passwordVisible2=false;
    ApiClient().checkPartyPermission().then((value) => {
          setState(() {
            Map response = value.data;
            if (response['status'] == '200') {
              Map result = response['result'];
              isGstRequired = result['gstin_required'] == 1;
            }
          }),
          //{login_required: 1, gstin_required: 1}}
          print(value.data),
        });

    if (widget.loginId.length == 10) {
      _mobile1.text = widget.loginId;
    }
    //
    else {
      _gstNumber.text = widget.loginId;
    }
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
          title: Text('Register')),
      body: Center(
        child: Padding(
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
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Name',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.person),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _mobile1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Phone Number',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.phone),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _mobile2,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Alternative Phone Number',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.phone),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _emailId,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Email Id',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.email),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _gstNumber,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'GST-IN',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.comment),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  maxLines: null,
                  autofocus: false,
                  controller: _address,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Address',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.map),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  obscureText: !_passwordVisible2,
                  controller: _password1,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Password',
                    fillColor: Colors.white,
                    suffixIcon: IconButton (icon:Icon(_passwordVisible2?Icons.visibility:Icons.visibility_off,color: Colors.pink,),onPressed: (){
                      setState(() {
                        _passwordVisible2=!_passwordVisible2;
                      });
                    }, ),
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,

                  controller: _password2,
                  obscureText: !_passwordVisible1,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Confirm Password',
                    fillColor: Colors.white,
                    suffixIcon: IconButton (icon:Icon(_passwordVisible1?Icons.visibility:Icons.visibility_off,color: Colors.pink,),onPressed: (){
                      setState(() {
                        _passwordVisible1=!_passwordVisible1;
                      });
                    }, ),
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
                      final name = _name.text;

                      final mobile1 = _mobile1.text;

                      final mobile2 = _mobile2.text;

                      final emailId = _emailId.text;

                      final password1 = _password1.text;

                      final password2 = _password2.text;

                      final address = _address.text;

                      final gstIn = _gstNumber.text;

                      if (name.length > 4 &&
                              mobile1.length > 9 &&
                              emailId.length > 4 &&
                              password1.length > 3 &&
                              password2.length > 3 &&
                              isGstRequired
                          ? gstIn.length == 16
                          : true) {
                        Map<String, dynamic> params = Map<String, dynamic>();
                        params['name'] = name;
                        params['gstin'] = gstIn;
                        params['email'] = emailId;
                        params['address1'] = address;
                        params['password'] = password1;
                        params['contact_number'] = mobile1;
                        params['confirm_password'] = password2;
                        params['alternative_contact_number'] = mobile2;

                        ProgressDialog dialog =
                            ProgressDialog(context, isDismissible: false);
                        dialog.show();
                        ApiClient().addPartyMaster(params).then((value) => {
                              setState(() {
                                dialog.hide();
                                print(value.data);
                                Map<String, dynamic> response = value.data;
                                if (response['status'] == '200') {
                                  UserProfile profile =
                                      UserProfile.fromJson(response['result']);

                                  UserLogin login =
                                      UserLogin(UserType.MASTER, profile.phone);

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
                      //
                      else {
                        AwesomeDialog(
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.RIGHSLIDE,
                                headerAnimationLoop: false,
                                title: 'This is Ignored',
                                desc: 'This is also Ignored',
                                body: Text(
                                  'Firm Name, Email Id, Mobile, and password is required',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                btnOkOnPress: () {},
                                btnOkIcon: Icons.cancel,
                                btnOkColor: Colors.red)
                            .show();
                      }
                    },
                    height: 55,
                    color: Colors.blue.shade300,
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
