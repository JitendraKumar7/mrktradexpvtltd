import 'package:image_picker/image_picker.dart';

import '../base/libraryExport.dart';

class PartyMasterViewScreen extends StatefulWidget {
  final int id;

  const PartyMasterViewScreen({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PartyMasterViewState();
}

class _PartyMasterViewState extends State<PartyMasterViewScreen> {
  Map result, profile;

  loadProfile() {
    ApiClient().getPartyMasterProfile(widget.id).then((value) => {
          setState(() {
            Map response = value.data;
            result = response['result'];
            print(response['result']);

            profile = Map();
            profile['id'] = result['id'];
            profile['name'] = result['party_master_name'];
            profile['address1'] = result['address'];
            profile['address2'] = result['address2'];
            profile['address3'] = result['address3'];
            profile['country'] = result['country'];
            profile['state'] = result['state'];
            profile['city'] = result['city'];
            profile['contact_number'] = result['contact_number'];
            profile['email'] = result['party_master_email'];
            profile['bank_name'] = result['bank_name'];
            profile['gstin'] = result['gstin'];
            profile['ifsc_code'] = result['ifsc_code'];
            profile['account_number'] = result['account_number'];
            profile['account_name'] = result['account_name'];
            profile['opening_balance'] = result['opening_balance'];
            profile['debit_credit'] = result['debit_credit'];
            profile['credit_period'] = result['credit_period'];
            profile['credit_days'] = result['credit_days'];
            profile['credit_amount'] = result['credit_amount'];
            profile['password'] = result['password'];
            profile['confirm_password'] = result['password'];
            profile['image'] = result['image'];
            profile['party_master_id'] = result['id'];
            profile['alternative_contact_number'] =
                result['alternative_contact_number'];

            String key = AppConstants.USER_LOGIN_CREDENTIAL;
            AppPreferences.getString(key).then((credential) => {
                  setState(() {
                    UserLogin login = UserLogin.formJson(credential);
                    if (login.isMaster && login.isLogin) {
                      UserProfile user = UserProfile.fromJson(profile);
                      String key = AppConstants.USER_LOGIN_DATA;
                      print(user);

                      AppPreferences.setString(key, jsonEncode(user.toJson()));
                    }
                  }),
                });
          })
        });
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Widget getProfile() {
    String _imagePath = result['image'] ?? '';
    return InkWell(
      onTap: () {
        ProgressDialog dialog = ProgressDialog(context);
        ImagePicker()
            .getImage(
                source: ImageSource.gallery,
                imageQuality: 85,
                maxHeight: 512,
                maxWidth: 512)
            .then((pickedFile) => {
                  print('picked file path ${pickedFile.path}'),
                  dialog.show(),
                  ApiClient().uploadFile(pickedFile.path).then((value) => {
                        setState(() {
                          Map response = value.data;
                          _imagePath = response['result'];
                          profile['image'] = response['result'];
                          print('Upload File Result ${value.data}');
                          ApiClient()
                              .updatePartyMaster(profile)
                              .then((value) => {
                                    dialog.hide().then((hide) => {
                                          setState(() {
                                            result = null;
                                            loadProfile();
                                            print(value.data);
                                          })
                                        })
                                  });
                        })
                      }),
                });
      },
      child: _imagePath.isEmpty
          ? Icon(
              Icons.person,
              size: 48,
            )
          : FadeInImage.assetNetwork(
              width: 80,
              height: 80,
              image: _imagePath,
              placeholder: 'images/iv_empty.png',
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String address0 = '';
    String address1 = '';
    String address2 = '';
    String address3 = '';
    String address4 = '';
    String address5 = '';
    if (result != null) {
      address0 = result['address'] ?? '';
      address1 = result['address2'] ?? '';
      address2 = result['address3'] ?? '';

      address3 = result['city'] ?? '';
      address4 = result['state'] ?? '';
      address5 = result['country'] ?? '';
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: result == null
            ? Center(
                child: GFLoader(loaderColorOne: Colors.white),
              )
            : ListView(
                padding: EdgeInsets.only(top: 24, bottom: 24),
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: getProfile(),
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'PERSONAL INFO',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue.shade300,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  UserInfoScreen(profile: profile),
                            ),
                          ).then((value) => {if (value) loadProfile()});
                        },
                      )
                    ],
                  ),
                  Divider(height: 24),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Name')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${result['party_master_name']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Email')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${result['party_master_email']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Phone No.')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${result['contact_number']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('GST-IN')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${result['gstin']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Address')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '$address0 $address1 $address2 $address3 $address4 $address5',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Password')),
                    Expanded(
                      flex: 2,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: <Widget>[
                          Container(
                            width: 300,
                            child: Text(
                              '${result['password']}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PasswordScreen(profile: profile),
                                ),
                              ).then((value) => {if (value) loadProfile()});
                            },
                          )
                        ],
                      ),
                    )
                  ]),
                  Divider(height: 24),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'BANKING DETAILS',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue.shade300,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BankInfoScreen(profile: profile),
                            ),
                          ).then((value) => {if (value) loadProfile()});
                        },
                      )
                    ],
                  ),
                  Divider(height: 24),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Group Type')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${result['group_type']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Bank Name')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${result['bank_name']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('IFSC Code')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${result['ifsc_code']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Acc. Number')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${result['account_number']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Acc. Holder')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${result['account_name']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(height: 24),
                  Center(
                    child: Text(
                      'BALANCE INFO',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue.shade300,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(height: 24),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Op. Balance')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '₹ ${result['opening_balance']} .00',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Cl. Balance')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '₹ ${result['closingBalance']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Debit/Credit')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${result['debit_credit']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Credit Period')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${result['credit_period']} Days',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(),
                  Row(children: <Widget>[
                    Expanded(flex: 1, child: Text('Credit Limit')),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '₹ ${result['credit_amount']} .00',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ]),
                  Divider(height: 24),
                  Row(children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${result['add_from']}',
                        style: TextStyle(fontSize: 8),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        ' ',
                        style: TextStyle(
                            fontSize: 18, color: Colors.blue.shade300),
                      ),
                    )
                  ]),
                  Divider(height: 24),
                ],
              ),
      ),
    );
  }
}
