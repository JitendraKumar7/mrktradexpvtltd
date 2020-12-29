import './base/libraryExport.dart';

class OffersScreen extends StatelessWidget {
  final KonnectDetails konnectDetails;

  OffersScreen(this.konnectDetails);

  @override
  Widget build(BuildContext context) {
    final List<CoverImage> _coverImage = konnectDetails.coverImage;
    final BasicInfo _basicInfo = konnectDetails.basicInfo;
    final List<Offer> _offers = konnectDetails.offer;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Offers'),
      ),
      body: ListView(
        children: <Widget>[
          CarouselSlider(images: _coverImage, info: _basicInfo),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(2),
            physics: NeverScrollableScrollPhysics(),
            children: _offers.map((item) {
              return Card(
                child: ListTile(
                  leading: InkWell(
                      onTap: () {
                        List<String> images = List<String>();
                        images.add(item.image);

                        if (item.image2.length > 45) {
                          images.add(item.image2);
                        }
                        if (item.image3.length > 45) {
                          images.add(item.image3);
                        }
                        if (item.image4.length > 45) {
                          images.add(item.image4);
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ImageSliderViewScreen(images: images),
                          ),
                        );
                      },
                      child: FadeInImage.assetNetwork(
                        image: item.image,
                        placeholder: 'images/iv_empty.png',
                        height: 80,
                        width: 60,
                      )),
                  title: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                  subtitle: Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Html(
                      data: item.campaign,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
