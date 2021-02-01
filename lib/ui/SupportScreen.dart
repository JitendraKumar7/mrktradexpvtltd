import './base/libraryExport.dart';

class SupportScreen extends StatefulWidget {
  final KonnectDetails konnectDetails;

  SupportScreen(this.konnectDetails);

  @override
  State<StatefulWidget> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final UrlLauncherService _service = locator<UrlLauncherService>();
  bool visible = false;

  @override
  void initState() {
    super.initState();
    String key = AppConstants.USER_LOGIN_CREDENTIAL;
    AppPreferences.getString(key).then((val) => {
          setState(() {
            visible = !UserLogin.formJson(val).isLogin;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    final List<CustomerSupport> _support =
        widget.konnectDetails.customerSupport;
    final List<CoverImage> _coverImage = widget.konnectDetails.coverImage;
    final BasicInfo _basicInfo = widget.konnectDetails.basicInfo;
    List<Widget> children = List();
    children.addAll(_support.map((item) {
      return ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: 18, right: 12, top: 12, bottom: 12),
              child: Text(
                item.title,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            KonnectButton(
              icon: Icon(Icons.call, color: Colors.grey),
              label: Text(
                item.contactNumber,
              ),
              onPressed: () {
                if (item.contactNumber.length > 9) {
                  _service.call(item.contactNumber);
                }
              },
            ),
            SizedBox(height: 24),
            Divider(thickness: 16),
          ]);
    }).toList());

    children.add(
      Visibility(
        visible: visible,
        child: _basicInfo.cardtype=="ecommerce"? InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    AdminLoginScreen(logo: _basicInfo.konnectLogo),
              ),
            );
          },
          child: Container(
            width: 300,
            height: 80,
            child: Center(
              child: Text(
                'Admin Dashboard',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ):Container(),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Support'),
      ),
      body: ListView(children: <Widget>[
        CarouselSlider(images: _coverImage, info: _basicInfo),
        Column(children: children),
      ]),
    );
  }
}
