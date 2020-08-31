import '../base/libraryExport.dart';

class PartyDashboardScreen extends StatefulWidget {
  final KonnectDetails konnectDetails;

  PartyDashboardScreen(this.konnectDetails);

  @override
  State<StatefulWidget> createState() => _PartyDashboardState();
}

class _PartyDashboardState extends State<PartyDashboardScreen> {
  List<CartSummery> cart = List<CartSummery>();
  UserProfile profile;

  @override
  void initState() {
    super.initState();

    AppPreferences.getString(AppConstants.USER_LOGIN_DATA).then((value) => {
          setState(() {
            print(value);
            Map response = jsonDecode(value);
            profile = UserProfile.fromJson(response);
          })
        });
    onBackPressed();
  }

  logout() {
    UserLogin login = UserLogin.formJson(null);
    String key = AppConstants.USER_LOGIN_CREDENTIAL;
    AppPreferences.setString(key, jsonEncode(login.toJson()));
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                DashboardScreen(widget.konnectDetails)),
        (Route<dynamic> route) => false);
  }

  onBackPressed() {
    print('Back Pressed');
    String key = AppConstants.USER_CART_DATA;
    AppPreferences.getString(key).then((value) => {
          setState(() {
            if (value != null) {
              cart = List<CartSummery>();
              for (Map json in jsonDecode(value)) {
                cart.add(CartSummery.fromJson(json));
              }
            }
          })
        });
  }

  Widget getCart() {
    return cart.isEmpty
        ? IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => OrderCartScreen(),
                ),
              ).then(
                (value) => onBackPressed(),
              );
            })
        : GFIconBadge(
            child: GFIconButton(
              size: GFSize.LARGE,
              color: Colors.transparent,
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => OrderCartScreen(),
                  ),
                ).then(
                  (value) => onBackPressed(),
                );
              },
            ),
            counterChild: GFBadge(
              shape: GFBadgeShape.circle,
              color: Colors.orangeAccent,
              child: Text(cart.length.toString()),
            ),
          );
  }

  Widget getProfile() {
    return profile.image.isEmpty
        ? Icon(
      Icons.perm_identity,
      size: 48,
    )
        : FadeInImage.assetNetwork(
      width: 80,
      height: 80,
      image: profile.image,
      placeholder: 'images/iv_empty.png',
    );
  }

  String getProfileName() {
    return profile.name ?? widget.konnectDetails.basicInfo.organisation;
  }

  String getProfileContact() {
    return profile.phone ?? widget.konnectDetails.basicInfo.categoryOfBusiness;
  }

  @override
  Widget build(BuildContext context) {
    BasicInfo basicInfo = widget.konnectDetails.basicInfo;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        title: Text('नमस्कार / welcome'),
        actions: <Widget>[
          getCart(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                height: 180,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: getProfile(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 5),
                      child: Text(getProfileName()),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 30),
                      child: Text(getProfileContact()),
                    ),
                  ],
                )),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PartyMasterViewScreen(id: profile.id),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_shopping_cart),
              title: Text('My Orders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PartySalesOrderScreen(
                      id: profile.id,
                    ),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('My Payment'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PartyPaymentScreen(
                      name: profile.name,
                      id: profile.id,
                    ),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('My Ledger'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PartyLedgerScreen(
                      id: profile.id,
                    ),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('My Invoice'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PartyInvoiceScreen(
                      id: profile.id,
                    ),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Pay via QR'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PartyPaymentQrScreen(
                      basic: widget.konnectDetails.basicInfo,
                      bank: widget.konnectDetails.bank,
                    ),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout (PM)'),
              onTap: () {
                Navigator.pop(context);
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.INFO,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Logout',
                    desc: 'Are you sure want to logout',
                    body: Text(
                      'Are you sure want to logout',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    btnCancelOnPress: () {},
                    btnCancelText: 'Cancel',
                    btnOkText: 'Logout',
                    btnOkOnPress: () {
                      logout();
                    }).show();
              },
            ),
            Divider(),
            SizedBox(height: 50)
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              color: Color.fromARGB(255, 255, 255, 255),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: GFCarousel(
                              height: MediaQuery.of(context).size.height,
                              items: widget.konnectDetails.coverImage
                                  .map((coverImage) {
                                return Image.network(coverImage.image,
                                    fit: BoxFit.cover, width: 1000.0);
                              }).toList(),
                              autoPlay: true,
                              pagination: true,
                              viewportFraction: 1.0,
                              onPageChanged: (index) {
                                setState(() {
                                  index;
                                });
                              }),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 5),
                          child: Text(
                            basicInfo.organisation,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 12),
                          child: Text(basicInfo.categoryOfBusiness),
                        ),
                      ]),
                  Positioned.fill(
                    left: 0.0,
                    bottom: 30.0,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: FadeInImage.assetNetwork(
                          image: basicInfo.konnectLogo,
                          placeholder: 'images/ic_konnect.png',
                          height: 80,
                          width: 60,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 3, color: Colors.white),
          Expanded(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AboutScreen(widget.konnectDetails),
                          ),
                        );
                      },
                      asset: 'images/home/ic_about.png',
                      label: 'About'),
                  VerticalDivider(color: Colors.black87),
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LocationScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_address.png',
                      label: 'Address'),
                  VerticalDivider(color: Colors.black87),
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ContactScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_contact.png',
                      label: 'Contact'),
                ],
              ),
            ),
          ),
          Divider(height: 3, color: Colors.black87),
          Expanded(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => CategoryScreen(),
                          ),
                        ).then(
                          (value) => onBackPressed(),
                        );
                      },
                      asset: 'images/home/ic_store.png',
                      label: 'Store'),
                  VerticalDivider(color: Colors.black87),
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  OffersScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_offers.png',
                      label: 'Offers'),
                  VerticalDivider(color: Colors.black87),
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  GalleryScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_gallery.png',
                      label: 'Gallery'),
                ],
              ),
            ),
          ),
          Divider(height: 3, color: Colors.black87),
          Expanded(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BankingScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_banking.png',
                      label: 'Banking'),
                  VerticalDivider(color: Colors.black87),
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RegisterScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_registration.png',
                      label: 'Registration'),
                  VerticalDivider(color: Colors.black87),
                  DashboardButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SupportScreen(widget.konnectDetails)),
                        );
                      },
                      asset: 'images/home/ic_support.png',
                      label: 'Support'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
