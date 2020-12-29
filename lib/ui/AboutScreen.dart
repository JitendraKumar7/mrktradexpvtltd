import './base/libraryExport.dart';

class AboutScreen extends StatelessWidget {
  final KonnectDetails konnectDetails;

  AboutScreen(this.konnectDetails);

  @override
  Widget build(BuildContext context) {
    final List<CoverImage> _coverImage = konnectDetails.coverImage;
    final BasicInfo _basicInfo = konnectDetails.basicInfo;
    final List<About> _about = konnectDetails.about;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('About'),
      ),
      body: ListView(
        children: <Widget>[
          CarouselSlider(images: _coverImage, info: _basicInfo),
          Column(
              children: _about.map((item) {
            return ListTile(
              title: Html(
                data: item.description,
              ),
            );
          }).toList()),
        ],
      ),
    );
  }
}
