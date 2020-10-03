import '../../base/libraryExport.dart';

class PartyMasterMobileScreen extends StatefulWidget {
  final String logo;

  const PartyMasterMobileScreen({Key key, @required this.logo})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PartyMasterMobileState();
}

class _PartyMasterMobileState extends State<PartyMasterMobileScreen> {
  TextEditingController _loginId = TextEditingController();

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
              TextFormField(
                maxLength: 15,
                autofocus: false,
                controller: _loginId,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter(RegExp(r'^[a-zA-Z0-9]+$'))
                ],
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: MaterialButton(
                  onPressed: () {
                    String loginId = _loginId.text.toUpperCase().trim();
                    if (loginId.length == 10 ||
                        loginId.length == 12 ||
                        loginId.length == 15) {
                      ProgressDialog dialog =
                          ProgressDialog(context, isDismissible: false);
                      dialog.show();

                      ApiClient().checkPartyMaster(loginId).then((value) => {
                            setState(() {
                              dialog.hide();
                              print(value.data);
                              Map<String, dynamic> response = value.data;
                              if (response['status'] == '200') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PartyMasterLoginScreen(
                                      loginId: loginId,
                                      logo: widget.logo,
                                    ),
                                  ),
                                );
                              }
                              // new user sign up
                              else {
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.ERROR,
                                  title: 'This is Ignored',
                                  desc: 'This is also Ignored',
                                  body: Text(
                                    'Don\'t have an account? Register!',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  dismissOnTouchOutside: false,
                                  btnCancelOnPress: () {},
                                  btnOkText: 'Register',
                                  btnOkOnPress: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            PartyMasterRegisterScreen(
                                                loginId: loginId),
                                      ),
                                    );
                                  },
                                ).show();
                              }
                            })
                          });
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
                          'Login Id wrong',
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
}
