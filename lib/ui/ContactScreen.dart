import './base/libraryExport.dart';

class ContactScreen extends StatelessWidget {
  final UrlLauncherService _service = locator<UrlLauncherService>();
  final KonnectDetails konnectDetails;

  ContactScreen(this.konnectDetails);

  @override
  Widget build(BuildContext context) {
    final List<CoverImage> _coverImage = konnectDetails.coverImage;
    final BasicInfo _basicInfo = konnectDetails.basicInfo;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Contact'),
      ),
      body: ListView(children: <Widget>[
        CarouselSlider(images: _coverImage, info: _basicInfo),
        Padding(
          padding: EdgeInsets.only(top: 24, left: 12, right: 12),
          child: KonnectButton(
            icon: Icon(Icons.call, color: Colors.grey),
            label: Text(
              _basicInfo.mobileNumber,
            ),
            onPressed: () {
              if (_basicInfo.mobileNumber.length > 9) {
                _service.call(_basicInfo.mobileNumber);
              }
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 24, left: 12, right: 12),
          child: KonnectButton(
            icon: Icon(Icons.email, color: Colors.grey),
            label: Text(
              _basicInfo.email,
            ),
            onPressed: () {
              if (_basicInfo.email.length > 9) {
                _service.sendEmail(_basicInfo.email);
              }
            },
          ),
        ),
        SizedBox(height: 24),
        Divider(thickness: 16),
      ]),
    );
  }
}
