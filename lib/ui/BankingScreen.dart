import './base/libraryExport.dart';

class BankingScreen extends StatelessWidget {
  final KonnectDetails konnectDetails;

  BankingScreen(this.konnectDetails);

  @override
  Widget build(BuildContext context) {
    final List<CoverImage> _coverImage = konnectDetails.coverImage;
    final BasicInfo _basicInfo = konnectDetails.basicInfo;
    final List<Bank> _bank = konnectDetails.bank;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Banking Details'),
      ),
      body: ListView(children: <Widget>[
        CarouselSlider(images: _coverImage, info: _basicInfo),
        Column(
            children: _bank.map((item) {
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 3),
                child: Text(
                  item.bankName,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 3, 24, 3),
                child: Text(
                  item.newBranch,
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 3, 24, 3),
                child: Text(
                  item.ifscCode,
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 3, 24, 3),
                child: Text(
                  item.accNo,
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 3, 24, 24),
                child: Text(
                  item.upi,
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
              Divider(thickness: 16),
            ],
          );
        }).toList()),
      ]),
    );
  }

  String createUPI(String name, String address) {
    String upi = 'upi://pay?pn=' +
        name +
        '&pa=' +
        address +
        '&cu=INR' +
        '&tn=KMB' +
        '&url=http://konnectmybusiness.com';
    //upi://pay?pa=192201502690@ICIC1000922.ifsc.npci&pn=JITENDRA%20KUMAR&mc=0000&tn=Pay%20to%20JITENDRA%20KUMAR&cu=INR
    return upi.replaceAll(' ', '+');
  }
}
