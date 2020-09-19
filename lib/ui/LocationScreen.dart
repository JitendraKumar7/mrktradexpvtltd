import './base/libraryExport.dart';

class LocationScreen extends StatelessWidget {
  final UrlLauncherService _service = locator<UrlLauncherService>();
  final KonnectDetails konnectDetails;

  LocationScreen(this.konnectDetails);

  @override
  Widget build(BuildContext context) {
    final List<CoverImage> _coverImage = konnectDetails.coverImage;
    final List<Location> _location = konnectDetails.location;
    final BasicInfo _basicInfo = konnectDetails.basicInfo;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Location'),
      ),
      body: ListView(children: <Widget>[
        CarouselSlider(images: _coverImage, info: _basicInfo),
        Column(
            children: _location.map((item) {
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 18, right: 12, top: 12, bottom: 12),
                child: Text(
                  item.addressType,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              KonnectButton(
                icon: Icon(Icons.location_city, color: Colors.grey),
                label: Text(item.address),
                onPressed: () {
                  if (item.latitude.length > 6 && item.longitude.length > 6) {
                    _service.googleMap(item.latitude, item.longitude);
                  }
                },
              ),
              KonnectButton(
                icon: Icon(Icons.call, color: Colors.grey),
                label: Text(
                  item.websiteUrl,
                ),
                onPressed: () {
                  if (item.websiteUrl.length > 9) {
                    _service.call(item.websiteUrl);
                  }
                },
              ),
              KonnectButton(
                icon: Icon(Icons.email, color: Colors.grey),
                label: Text(
                  item.email,
                ),
                onPressed: () {
                  if (item.email.length > 9) {
                    _service.sendEmail(item.email);
                  }
                },
              ),
              KonnectButton(
                icon: Icon(Icons.description, color: Colors.grey),
                label: Text(
                  item.gstNo,
                ),
                onPressed: () {},
              ),
              SizedBox(height: 18),
              Divider(thickness: 16),
            ],
          );
        }).toList()),
      ]),
    );
  }
}
