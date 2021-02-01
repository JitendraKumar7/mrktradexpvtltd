import '../../base/libraryExport.dart';

class PasswordScreen extends StatefulWidget {
  final Map profile;

  PasswordScreen({Key key, this.profile}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController _password1 = TextEditingController();
  TextEditingController _password2 = TextEditingController();
  TextEditingController _password3 = TextEditingController();
  bool _passwordVisible,_passwordVisible1,_passwordVisible2;
  @override
  void initState() {
    _passwordVisible=false;
    _passwordVisible1=false;
    _passwordVisible2=false;

    super.initState();

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
          title: Text('Change Password')),
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
                  obscureText: !_passwordVisible1,
                  autofocus: false,

                  controller: _password1,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Old Password',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon:IconButton (icon:Icon(_passwordVisible1?Icons.visibility:Icons.visibility_off,color: Colors.pink,),onPressed: (){
                      setState(() {
                        _passwordVisible1=!_passwordVisible1;
                      });
                    }, ),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  obscureText: !_passwordVisible2,
                  controller: _password2,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'New Password',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon:IconButton (icon:Icon(_passwordVisible2?Icons.visibility:Icons.visibility_off,color: Colors.pink,),onPressed: (){
                      setState(() {
                        _passwordVisible2=!_passwordVisible2;
                      });
                    }, ),












                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  obscureText:! _passwordVisible,
                  controller: _password3,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    filled: true,
                    suffixIcon:IconButton (icon:Icon(_passwordVisible?Icons.visibility:Icons.visibility_off,color: Colors.pink,),onPressed: (){
                      setState(() {
                        _passwordVisible=!_passwordVisible;
                      });
                    }, ),
                    hintText: 'Confirm Password',
                    fillColor: Colors.white,
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
                      final password1 = _password1.text;

                      final password2 = _password2.text;

                      final password3 = _password2.text;

                      if (password1.length > 3 &&
                          password2.length > 3 &&
                          password3.length > 3) {
                        if (widget.profile['password'] == password1 &&
                            password2 == password3) {
                          Map params = widget.profile;

                          params['confirm_password'] = password3;
                          params['password'] = password2;

                          ProgressDialog dialog =
                              ProgressDialog(context, isDismissible: false);
                          dialog.show();
                          ApiClient()
                              .updatePartyMaster(params)
                              .then((value) => {
                                    setState(() {
                                      dialog.hide();
                                      print(value.data);
                                      Map<String, dynamic> response =
                                          value.data;
                                      if (response['status'] == '200') {
                                        Navigator.of(context).pop(true);
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
                        } else {
                          AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.RIGHSLIDE,
                                  headerAnimationLoop: false,
                                  title: 'This is Ignored',
                                  desc: 'This is also Ignored',
                                  body: Text(
                                    'Password not matched!',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  btnOkOnPress: () {},
                                  btnOkIcon: Icons.cancel,
                                  btnOkColor: Colors.red)
                              .show();
                        }
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
                                  'Password is Required',
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
                      'Update',
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

class BankInfoScreen extends StatefulWidget {
  final Map profile;

  const BankInfoScreen({Key key, this.profile}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _BankingScreenState();
}

class _BankingScreenState extends State<BankInfoScreen> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller1.text = widget.profile['bank_name'] ?? '';
    _controller2.text = widget.profile['ifsc_code'] ?? '';
    _controller3.text = widget.profile['account_number'] ?? '';
    _controller4.text = widget.profile['account_name'] ?? '';
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
        title: Text('Update Banking'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Container(
            padding: EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              color: Colors.grey.shade300,
              border: new Border.all(color: Colors.grey.shade50, width: 1),
              borderRadius: new BorderRadius.circular(12.0),
            ),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _controller1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Bank Name',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _controller2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'IFSC Code',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _controller3,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Account Number',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _controller4,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Account Holder',
                    fillColor: Colors.white,
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
                      final text1 = _controller1.text;

                      final text2 = _controller2.text;

                      final text3 = _controller3.text;

                      final text4 = _controller4.text;

                      if (text1.length > 2 &&
                          text2.length > 6 &&
                          text3.length > 6 &&
                          text4.length > 6) {
                        Map params = widget.profile;
                        params['bank_name'] = text1;
                        params['ifsc_code'] = text2;
                        params['account_name'] = text4;
                        params['account_number'] = text3;

                        ProgressDialog dialog =
                            ProgressDialog(context, isDismissible: false);
                        dialog.show();
                        ApiClient().updatePartyMaster(params).then((value) => {
                              setState(() {
                                dialog.hide();
                                print(value.data);
                                Map response = value.data;
                                if (response['status'] == '200') {
                                  Navigator.of(context).pop(true);
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
                                  'All Fields is Required',
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
                      'Update',
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

class UserInfoScreen extends StatefulWidget {
  final Map profile;

  UserInfoScreen({Key key, this.profile}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  TextEditingController _mobile1 = TextEditingController();
  TextEditingController _emailId = TextEditingController();
  TextEditingController _address1 = TextEditingController();
  TextEditingController _address2 = TextEditingController();
  TextEditingController _address3 = TextEditingController();
  TextEditingController _address4 = TextEditingController();
  TextEditingController _address5 = TextEditingController();
  TextEditingController _address6 = TextEditingController();

  @override
  void initState() {
    super.initState();

    _mobile1.text = widget.profile['alternative_contact_number'] ?? '';
    _emailId.text = widget.profile['email'] ?? '';

    _address1.text = widget.profile['address1'] ?? '';
    _address2.text = widget.profile['address2'] ?? '';
    _address3.text = widget.profile['address3'] ?? '';

    _address4.text = widget.profile['city'] ?? '';
    _address5.text = widget.profile['state'] ?? '';
    _address6.text = widget.profile['country'] ?? '';
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
        title: Text('Update Profile'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: new BoxDecoration(
              color: Colors.grey.shade300,
              border: new Border.all(color: Colors.grey.shade50, width: 1),
              borderRadius: new BorderRadius.circular(12.0),
            ),
            width: MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _mobile1,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Alternative Phone Number',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.phone),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
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
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _address1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Address Line 1',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.location_city),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _address2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Address Line 2',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.location_city),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _address3,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Address Line 3',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.location_city),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _address4,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'City',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.location_city),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _address5,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'State',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.location_city),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  autofocus: false,
                  controller: _address6,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Country',
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.location_city),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: MaterialButton(
                    onPressed: () {
                      final email = _emailId.text;

                      final mobile = _mobile1.text;

                      final address1 = _address1.text;
                      final address2 = _address2.text;
                      final address3 = _address3.text;
                      final address4 = _address4.text;
                      final address5 = _address5.text;
                      final address6 = _address6.text;

                      if (address1.length > 3) {
                        Map params = widget.profile;

                        params['email'] = email;
                        params['address1'] = address1;
                        params['address2'] = address2;
                        params['address3'] = address3;
                        params['city'] = address4;
                        params['state'] = address5;
                        params['country'] = address6;
                        params['alternative_contact_number'] = mobile;

                        ProgressDialog dialog =
                            ProgressDialog(context, isDismissible: false);
                        dialog.show();
                        ApiClient().updatePartyMaster(params).then((value) => {
                              setState(() {
                                dialog.hide();
                                print(value.data);
                                Map response = value.data;
                                if (response['status'] == '200') {
                                  Navigator.of(context).pop(true);
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
                                  'Address 1 Fields is Required',
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
                      'Update',
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
