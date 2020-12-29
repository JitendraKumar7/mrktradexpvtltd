import '../ui/base/libraryExport.dart';

class CarouselSlider extends StatelessWidget {
  final List<CoverImage> images;
  final BasicInfo info;

  const CarouselSlider({Key key, @required this.images, @required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 220,
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
                          items: images.map(
                            (image) {
                              return Image.network(image.image,
                                  fit: BoxFit.cover, width: 1000.0);
                            },
                          ).toList(),
                          autoPlay: true,
                          pagination: true,
                          viewportFraction: 1.0),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black,
                    ),
                  ],
                ),
                Positioned.fill(
                    left: 6,
                    bottom: 6,
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: FadeInImage.assetNetwork(
                              image: info.konnectLogo,
                              placeholder: 'images/ic_konnect.png',
                              height: 80,
                              width: 60,
                            )))),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 5),
            child: Text(
              info.organisation,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 12),
            child: Text(info.categoryOfBusiness),
          ),
          Divider(thickness: 16),
        ],
      ),
    );
  }
}
