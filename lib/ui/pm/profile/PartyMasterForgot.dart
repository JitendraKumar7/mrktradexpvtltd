import '../../base/libraryExport.dart';

class PartyMasterForgotScreen extends StatefulWidget {
  final String loginId;
  final String logo;

  const PartyMasterForgotScreen({Key key, this.loginId, this.logo})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PartyMasterForgotState();
}

class _PartyMasterForgotState extends State<PartyMasterForgotScreen> {
  TextEditingController _loginId = TextEditingController();
  TextEditingController _password1 = TextEditingController();
  TextEditingController _password2 = TextEditingController();
  TextEditingController _password3 = TextEditingController();

  @override
  void initState() {
    super.initState();

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
          title: Text('Forgot Password')),
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
              SizedBox(height: 72.0),
              TextFormField(
                autofocus: true,
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
                controller: _password1,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'OTP',
                  prefixIcon: Icon(Icons.lock),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                ),
              ),
              SizedBox(height: 48.0),
              TextFormField(
                autofocus: true,
                controller: _password2,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'New Password',
                  prefixIcon: Icon(Icons.lock),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                ),
              ),
              SizedBox(height: 48.0),
              TextFormField(
                autofocus: true,
                controller: _password3,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
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
                    String pass1 = _password1.text;
                    String pass2 = _password2.text;
                    String pass3 = _password3.text;
                    if (loginId.length > 9 &&
                        pass1.length > 3 &&
                        pass2.length > 3) {
                      if (pass2 == pass3) {
                        ProgressDialog dialog =
                            ProgressDialog(context, isDismissible: false);
                        dialog.show();
                        ApiClient()
                            .resetPass(loginId, pass1, pass2)
                            .then((value) => {
                                  setState(() {
                                    dialog.hide();
                                    print(value.data);
                                    Map<String, dynamic> response = value.data;
                                    if (response['status'] == '200') {
                                      Navigator.pop(context);
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
                          animType: AnimType.SCALE,
                          dialogType: DialogType.ERROR,
                          title: 'This is Ignored',
                          desc: 'This is also Ignored',
                          body: Text(
                            'Password not match.',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          dismissOnTouchOutside: false,
                          btnOkOnPress: () {},
                        ).show();
                      }
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
}
